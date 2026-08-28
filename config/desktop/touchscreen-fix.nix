# Fix de pantalla tactil Huawei MateBook (FTSC1000 / FocalTech vía I2C-HID).
#
# Problema: al bootear el kernel intenta el probe del I2C-HID demasiado pronto,
# antes de que el firmware del dispositivo termine de levantarse. El probe
# falla (EREMOTEIO/lost arbitration) y el touchscreen queda "mudo": registrado
# como input pero sin eventos. Cerrar la tapa (suspend/resume) lo revivía.
#
# Solución (la que ya funcionó en Arch con un timer): esperar a que el
# dispositivo se estabilice tras el boot y entonces forzar un re-probe
# (unbind/bind) del driver i2c_hid_acpi.
{ config, lib, pkgs, ... }:

let
  device = "i2c-FTSC1000:00";
  controller = "i2c_designware.1";

  kickScript = pkgs.writeShellScriptBin "touchscreen-kick" ''
    DEVICE="${device}"
    CTRL="/sys/bus/platform/devices/${controller}"

    log() { echo "touchscreen: $*"; }

    if [ ! -e "/sys/bus/i2c/devices/$DEVICE" ]; then
      log "device no presente, nada que hacer"
      exit 0
    fi

    # Reactivar la controladora si quedó suspendida.
    echo on > "$CTRL/power/control" 2>/dev/null || true

    # Re-probe siempre: aunque el device tenga input registrado, puede estar
    # "mudo" (probe temprano fallido). Al correr retrasado, el firmware ya
    # debería estar listo y el re-probe lo revivirá limpiamente.
    log "re-probe del driver i2c_hid_acpi"
    echo "$DEVICE" > "/sys/bus/i2c/drivers/i2c_hid_acpi/unbind" 2>/dev/null || true
    sleep 2
    echo "$DEVICE" > "/sys/bus/i2c/drivers/i2c_hid_acpi/bind" 2>/dev/null || true
    sleep 1
    if [ -e "/sys/bus/i2c/devices/$DEVICE/input" ]; then
      log "re-probe OK, input presente"
    else
      log "re-probe sin input (aun podria estar levantandose)"
    fi
  '';
in
{
  # Prevención: desactivar autosuspend de la controladora del touchscreen.
  systemd.services.touchscreen-nosuspend = {
    description = "Deshabilitar autosuspend del touchscreen I2C";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "ts-nosuspend" ''
        echo on > /sys/bus/platform/devices/${controller}/power/control 2>/dev/null || true
        echo on > /sys/bus/i2c/devices/${device}/power/control 2>/dev/null || true
      '';
    };
  };

  # Revival tardío: esperar a que el firmware del touchscreen se estabilice
  # tras el boot y entonces re-probar el driver. Un systemd.timer lo dispara.
  systemd.services.touchscreen-kick = {
    description = "Revivir pantalla tactil colgada (re-probe tardio I2C HID)";
    after = [ "systemd-modules-load.service" "touchscreen-nosuspend.service" ];
    wants = [ "touchscreen-nosuspend.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${kickScript}/bin/touchscreen-kick";
    };
  };

  systemd.timers.touchscreen-kick = {
    description = "Timer para re-probar la pantalla tactil tras el boot";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Disparar una sola vez al arranque, con un pequeño retraso para dar
      # tiempo al firmware del dispositivo a levantarse.
      OnBootSec = "10s";
      Unit = "touchscreen-kick.service";
    };
  };
}
