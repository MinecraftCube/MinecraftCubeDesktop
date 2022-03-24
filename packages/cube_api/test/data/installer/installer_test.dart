import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Installer', () {
    test('should parse correct vanilla json', () async {
      final installer = Installer.fromJson(jsonDecode(vanillaRaw));
      expect(
        installer,
        equals(
          const Installer(
            'official_vanilla_1.17', '', JarType.vanilla,
            'http://localhost:PORT/vanilla_1.17.jar',
            mapZipPath: '', // legacy issue. not affect the future
          ),
        ),
      );
    });
    test('should parse correct vanillaMap json', () async {
      final installer = Installer.fromJson(jsonDecode(vanillaMapRaw));
      expect(
        installer,
        equals(
          const Installer(
            'official_vanilla_1.17_map',
            '',
            JarType.vanilla,
            'http://localhost:PORT/vanilla_1.17.jar',
            mapZipPath: 'http://localhost:PORT/minecraft/test_map.zip',
          ),
        ),
      );
    });
    test('should parse correct paper json', () async {
      final installer = Installer.fromJson(jsonDecode(paperRaw));
      expect(
        installer,
        equals(
          const Installer(
            'paper_1.17.1',
            '',
            JarType.vanilla,
            'http://localhost:PORT/paper-1.17.1-151.jar',
            mapZipPath: '',
          ),
        ),
      );
    });
    test('should parse correct forge json', () async {
      final installer = Installer.fromJson(jsonDecode(forgeRaw));
      expect(
        installer,
        equals(
          const Installer(
            'forge_1.15.2', '', JarType.forge,
            'http://localhost:PORT/forge_installer_1.15.2.jar',
            mapZipPath: '', // legacy issue. not affect the future
          ),
        ),
      );
    });
    test('should parse correct forgeMap json', () async {
      final installer = Installer.fromJson(jsonDecode(forgeMapRaw));
      expect(
        installer,
        equals(
          const Installer(
            'forge_1.15.2_map',
            '',
            JarType.forge,
            'http://localhost:PORT/forge_installer_1.15.2.jar',
            mapZipPath: 'http://localhost:PORT/minecraft/test_map.zip',
          ),
        ),
      );
    });
    test('should parse correct forge mods json', () async {
      final installer = Installer.fromJson(jsonDecode(forgeModsRaw));
      expect(
        installer,
        equals(
          const Installer(
            'forge_1.15.2_mods',
            '',
            JarType.forge,
            'http://localhost:PORT/forge_installer_1.15.2.jar',
            mapZipPath: '',
            modelSettings: [
              // ,{"name":"NaturesCompass-1.17.1-1.9.2-forge","program":"NaturesCompass-1.17.1-1.9.2-forge.jar","path":"http://localhost:PORT/minecraft/forge/NaturesCompass-1.17.1-1.9.2-forge.jar"},{"name":"MouseTweaks-2.14-mc1.17.1","program":"MouseTweaks-2.14-mc1.17.1.jar","path":"http://localhost:PORT/minecraft/forge/MouseTweaks-2.14-mc1.17.1.jar"},{"name":"Placebo-1.15.2-3.1.1","program":"Placebo-1.15.2-3.1.1.jar","path":"http://localhost:PORT/minecraft/forge/Placebo-1.15.2-3.1.1.jar
              ModelSetting(
                name: 'appleskin-forge-mc1.17.1-2.1.0',
                program: 'appleskin-forge-mc1.17.1-2.1.0.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/appleskin-forge-mc1.17.1-2.1.0.jar',
              ),
              ModelSetting(
                name: 'NaturesCompass-1.17.1-1.9.2-forge',
                program: 'NaturesCompass-1.17.1-1.9.2-forge.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/NaturesCompass-1.17.1-1.9.2-forge.jar',
              ),
              ModelSetting(
                name: 'MouseTweaks-2.14-mc1.17.1',
                program: 'MouseTweaks-2.14-mc1.17.1.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/MouseTweaks-2.14-mc1.17.1.jar',
              ),
              ModelSetting(
                name: 'Placebo-1.15.2-3.1.1',
                program: 'Placebo-1.15.2-3.1.1.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/Placebo-1.15.2-3.1.1.jar',
              ),
            ],
          ),
        ),
      );
    });
    test('should parse correct forge modpack json', () async {
      final installer = Installer.fromJson(jsonDecode(forgeModpackRaw));
      expect(
        installer,
        equals(
          const Installer(
            'forge_1.15.2_modpack',
            '',
            JarType.forge,
            'http://localhost:PORT/forge_installer_1.15.2.jar',
            mapZipPath: '',
            modelPack: ModelPack(
              path: 'http://localhost:PORT/minecraft/forge/mods.zip',
              description: '',
            ),
          ),
        ),
      );
    });
    test('should parse correct forge mods map json', () async {
      final installer = Installer.fromJson(jsonDecode(forgeModsMapRaw));
      expect(
        installer,
        equals(
          const Installer(
            'forge_1.15.2_mods',
            '',
            JarType.forge,
            'http://localhost:PORT/forge_installer_1.15.2.jar',
            mapZipPath: 'http://localhost:PORT/minecraft/test_map.zip',
            modelSettings: [
              // ,{"name":"NaturesCompass-1.17.1-1.9.2-forge","program":"NaturesCompass-1.17.1-1.9.2-forge.jar","path":"http://localhost:PORT/minecraft/forge/NaturesCompass-1.17.1-1.9.2-forge.jar"},{"name":"MouseTweaks-2.14-mc1.17.1","program":"MouseTweaks-2.14-mc1.17.1.jar","path":"http://localhost:PORT/minecraft/forge/MouseTweaks-2.14-mc1.17.1.jar"},{"name":"Placebo-1.15.2-3.1.1","program":"Placebo-1.15.2-3.1.1.jar","path":"http://localhost:PORT/minecraft/forge/Placebo-1.15.2-3.1.1.jar
              ModelSetting(
                name: 'appleskin-forge-mc1.17.1-2.1.0',
                program: 'appleskin-forge-mc1.17.1-2.1.0.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/appleskin-forge-mc1.17.1-2.1.0.jar',
              ),
              ModelSetting(
                name: 'NaturesCompass-1.17.1-1.9.2-forge',
                program: 'NaturesCompass-1.17.1-1.9.2-forge.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/NaturesCompass-1.17.1-1.9.2-forge.jar',
              ),
              ModelSetting(
                name: 'MouseTweaks-2.14-mc1.17.1',
                program: 'MouseTweaks-2.14-mc1.17.1.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/MouseTweaks-2.14-mc1.17.1.jar',
              ),
              ModelSetting(
                name: 'Placebo-1.15.2-3.1.1',
                program: 'Placebo-1.15.2-3.1.1.jar',
                path:
                    'http://localhost:PORT/minecraft/forge/Placebo-1.15.2-3.1.1.jar',
              ),
            ],
          ),
        ),
      );
    });
  });
}

const vanillaRaw =
    r'''{"name":"official_vanilla_1.17","description":"","type":"vanilla","serverPath":"http://localhost:PORT/vanilla_1.17.jar","modelSettings":[],"modelPack":null,"mapZipPath":""}''';
// const vanillaCorruptRaw =
//     r'''"name":"official_vanilla_1.17","description":"","type":"vanilla","serverPath":"http://localhost:PORT/vanilla_1.17.jar","modelSettings":[],"modelPack":null,"mapZipPath":""}''';
const vanillaMapRaw =
    r'''{"name":"official_vanilla_1.17_map","description":"","type":"vanilla","serverPath":"http://localhost:PORT/vanilla_1.17.jar","modelSettings":[],"modelPack":null,"mapZipPath":"http://localhost:PORT/minecraft/test_map.zip"}''';
const paperRaw =
    r'''{"name":"paper_1.17.1","description":"","type":"vanilla","serverPath":"http://localhost:PORT/paper-1.17.1-151.jar","modelSettings":[],"modelPack":null,"mapZipPath":""}''';
const forgeRaw =
    r'''{"name":"forge_1.15.2","description":"","type":"forge","serverPath":"http://localhost:PORT/forge_installer_1.15.2.jar","modelSettings":[],"modelPack":null,"mapZipPath":""}''';
const forgeMapRaw =
    r'''{"name":"forge_1.15.2_map","description":"","type":"forge","serverPath":"http://localhost:PORT/forge_installer_1.15.2.jar","modelSettings":[],"modelPack":null,"mapZipPath":"http://localhost:PORT/minecraft/test_map.zip"}''';
const forgeModpackRaw =
    r'''{"name":"forge_1.15.2_modpack","description":"","type":"forge","serverPath":"http://localhost:PORT/forge_installer_1.15.2.jar","modelSettings":[],"modelPack":{"description":"","path":"http://localhost:PORT/minecraft/forge/mods.zip"},"mapZipPath":""}''';
const forgeModsRaw =
    r'''{"name":"forge_1.15.2_mods","description":"","type":"forge","serverPath":"http://localhost:PORT/forge_installer_1.15.2.jar","modelSettings":[{"name":"appleskin-forge-mc1.17.1-2.1.0","program":"appleskin-forge-mc1.17.1-2.1.0.jar","path":"http://localhost:PORT/minecraft/forge/appleskin-forge-mc1.17.1-2.1.0.jar"},{"name":"NaturesCompass-1.17.1-1.9.2-forge","program":"NaturesCompass-1.17.1-1.9.2-forge.jar","path":"http://localhost:PORT/minecraft/forge/NaturesCompass-1.17.1-1.9.2-forge.jar"},{"name":"MouseTweaks-2.14-mc1.17.1","program":"MouseTweaks-2.14-mc1.17.1.jar","path":"http://localhost:PORT/minecraft/forge/MouseTweaks-2.14-mc1.17.1.jar"},{"name":"Placebo-1.15.2-3.1.1","program":"Placebo-1.15.2-3.1.1.jar","path":"http://localhost:PORT/minecraft/forge/Placebo-1.15.2-3.1.1.jar"}],"modelPack":null,"mapZipPath":""}''';
const forgeModsMapRaw =
    r'''{"name":"forge_1.15.2_mods","description":"","type":"forge","serverPath":"http://localhost:PORT/forge_installer_1.15.2.jar","modelSettings":[{"name":"appleskin-forge-mc1.17.1-2.1.0","program":"appleskin-forge-mc1.17.1-2.1.0.jar","path":"http://localhost:PORT/minecraft/forge/appleskin-forge-mc1.17.1-2.1.0.jar"},{"name":"NaturesCompass-1.17.1-1.9.2-forge","program":"NaturesCompass-1.17.1-1.9.2-forge.jar","path":"http://localhost:PORT/minecraft/forge/NaturesCompass-1.17.1-1.9.2-forge.jar"},{"name":"MouseTweaks-2.14-mc1.17.1","program":"MouseTweaks-2.14-mc1.17.1.jar","path":"http://localhost:PORT/minecraft/forge/MouseTweaks-2.14-mc1.17.1.jar"},{"name":"Placebo-1.15.2-3.1.1","program":"Placebo-1.15.2-3.1.1.jar","path":"http://localhost:PORT/minecraft/forge/Placebo-1.15.2-3.1.1.jar"}],"modelPack":null,"mapZipPath":"http://localhost:PORT/minecraft/test_map.zip"}''';
