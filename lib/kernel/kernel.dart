library kernel;

import 'package:WhynClient/kernel/config.dart';
import 'package:WhynClient/switcher/switcher.dart';
import 'package:WhynClient/mailer_hub/mailer_hub.dart';
import 'package:WhynClient/map_component/map_component.dart';
import 'package:WhynClient/help/help.dart';
import 'package:WhynClient/settings_component/settings_component.dart';

/// Collect app components
class Kernel {
  static Kernel _kernel = new Kernel._internal();

  // Map<String, Kernable> _kernels;

  // switcher
  Switcher switcher;

  // mailer
  Mailer mailer;

  HelpComponent helpComponent;
  SettingsComponent settings;
  ZoomComponent zoomComponent;
  Director director;

  MapSource mapSource;
  MapContainer mapContainer;

  factory Kernel() => _kernel;

  Kernel._internal();

  void burn() {

    (new Config()).load();

    mailer = new Mailer();

    helpComponent = new HelpComponent();
    settings = new SettingsComponent();

    director = new Director();

    // mapSource = new Consolemap();
    mapSource = new Yamaps("js/map.js");
    mapContainer = new MapContainer(mapSource);

    zoomComponent = new ZoomComponent();
    new RotateComponent(mapContainer);
    new GlobComponent();

    switcher = new Switcher();
  }

}