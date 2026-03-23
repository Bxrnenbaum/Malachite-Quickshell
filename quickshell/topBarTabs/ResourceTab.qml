import "../"
import "../gauges"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtSensors 5.15
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland

RowLayout {

    CpuGauge {
    }

    RamGauge {
    }

    GpuGauge {
    }

}
