# Fix de pantalla tactil Huawei MateBook (FTSC1000 / FocalTech vía I2C-HID).
#
# Problema: al reiniciar el bus i2c_designware.1 pierde "arbitración" durante
# el probe temprano y el touchscreen queda colgado. Cerrar la tapa genera un
# ciclo de suspend/resume que lo revive.
#
# Solución (ambos):
#   1) Prevención: deshabilitar autosuspend del bus/device al arrancar.
#   2) Revival: re-probe del driver (unbind/bind) si el device queda colgado.
{ config, lib, pkgs, ... }:

let
  # Device I2C HID del touchscreen en este equipo.
  device = "i2c-FTSC1000:00";
  bus = "i2c-2";

  kickScript = pkgs.writeShellScriptBin "touchscreen-kick" ''
    set -e
    DRIVER="/sys/bus/i2c/drivers/i2c_hid_acpi"
    DEVICE="/sys/bus/i2c/devices/${device}"

    if [ ! -d "$DEVICE" ]; then
      echo "touchscreen: $DEVICE no presente, nada que hacer"
      exit 0
    fi

    # Marcar que el driver no se auto-suspenda.
    echo on > "$DEVICE/power/control" 2>/dev/null || true

    # Detectar si el device está colgado: checar que tenga input registrado.
    # Un touchscreen sano convive con el driver; si el probe falló, el device
    # existe pero sin eventos / con errores de report.
    if ! ls "$DEVICE/input" >/dev/null 2>&1; then
      echo "touchscreen: no hay input, fuerzo re-probe"
      echo "$device" > "$DRIVER/unbind" 2>/dev/null || true
      sleep 1
      echo "$device" > "$DRIVER/bind" 2>/dev/null || true
      echo "touchscreen: re-probe ejecutado"
    else
      echo "touchscreen: sano, sin acción"
    fi
  '';
in
{
  # 1) Prevención: desactivar autosuspend del bus y del device.
  systemd.services.touchscreen-nosuspend = {
    description = "Deshabilitar autosuspend del touchscreen I2C";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "ts-nosuspend" ''
        echo on > /sys/bus/i2c/devices/${bus}/power/control 2>/dev/null || true
        echo on > /sys/bus/i2c/devices/${device}/power/control 2>/dev/null || true
      '';
    };
  };

  # 2) Revival: re-probe al arranque si el touchscreen quedó colgado.
  systemd.services.touchscreen-kick = {
    description = "Revivir pantalla tactil colgada (re-probe I2C HID)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" "touchscreen-nosuspend.service" ];
    wants = [ "touchscreen-nosuspend.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${kickScript}/bin/touchscreen-kick";
    };
  };
}
