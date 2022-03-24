import 'package:cube_api/cube_api.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/app_server_properties.i18n.dart';

enum ServerPropertyGamemode {
  survival,
  creative,
  adventure,
  spectator,
}

extension ServerPropertyGamemodeExtension on ServerPropertyGamemode {
  String get name {
    switch (this) {
      case ServerPropertyGamemode.survival:
        return gameModeSurvival.i18n;
      case ServerPropertyGamemode.creative:
        return gameModeCreative.i18n;
      case ServerPropertyGamemode.adventure:
        return gameModeAdventure.i18n;
      case ServerPropertyGamemode.spectator:
        return gameModeSpectator.i18n;
      default:
        return '';
    }
  }
}

enum ServerPropertyDifficulty {
  peaceful,
  easy,
  normal,
  hard,
}

extension ServerPropertyDifficultyExtension on ServerPropertyDifficulty {
  String get name {
    switch (this) {
      case ServerPropertyDifficulty.peaceful:
        return difficultyPeaceful.i18n;
      case ServerPropertyDifficulty.easy:
        return difficultyEasy.i18n;
      case ServerPropertyDifficulty.normal:
        return difficultyNormal.i18n;
      case ServerPropertyDifficulty.hard:
        return difficultyHard.i18n;
      default:
        return '';
    }
  }
}

Iterable<CommonProperty> getAppServerProperties() {
  return [
    BoolServerProperty(
      name: allowFlight.i18n,
      fieldName: 'allow-flight',
      value: false,
      description: allowFlightDesc.i18n,
    ),
    BoolServerProperty(
      name: allowNether.i18n,
      fieldName: 'allow-nether',
      value: true,
      description: allowNetherDesc.i18n,
    ),
    BoolServerProperty(
      name: broadcastRconToOps.i18n,
      fieldName: 'broadcast-rcon-to-ops',
      value: true,
      description: broadcastRconToOpsDesc.i18n,
    ),
    BoolServerProperty(
      name: broadcastConsoleToOps.i18n,
      fieldName: 'broadcast-console-to-ops',
      value: true,
      description: broadcastConsoleToOpsDesc.i18n,
    ),
    // * enum
    // peaceful (0)
    // easy (1)
    // normal (2)
    // hard (3)
    IntegerServerProperty(
      name: difficulty.i18n,
      fieldName: 'difficulty',
      value: 1,
      description: difficultyDesc.i18n,
      selectables: {
        ServerPropertyDifficulty.peaceful.index:
            ServerPropertyDifficulty.peaceful.name,
        ServerPropertyDifficulty.easy.index: ServerPropertyDifficulty.easy.name,
        ServerPropertyDifficulty.normal.index:
            ServerPropertyDifficulty.normal.name,
        ServerPropertyDifficulty.hard.index: ServerPropertyDifficulty.hard.name,
      },
    ),
    BoolServerProperty(
      name: enableCommandBlock.i18n,
      fieldName: 'enable-command-block',
      value: false,
      description: enableCommandBlockDesc.i18n,
    ),
    BoolServerProperty(
      name: enableQuery.i18n,
      fieldName: 'enable-query',
      value: false,
      description: enableQueryDesc.i18n,
    ),
    BoolServerProperty(
      name: enableRcon.i18n,
      fieldName: 'enable-rcon',
      value: false,
      description: enableRconDesc.i18n,
    ),
    BoolServerProperty(
      name: forceGamemode.i18n,
      fieldName: 'force-gamemode',
      value: false,
      description: forceGamemodeDesc.i18n,
    ),
    IntegerServerProperty(
      name: functionPermissionLevel.i18n,
      fieldName: 'function-permission-level',
      value: 2,
      description: functionPermissionLevelDesc.i18n,
    ),
    // * enum
    // survival (0)
    // creative (1)
    // adventure (2)
    // spectator (3)
    IntegerServerProperty(
      name: gamemode.i18n,
      fieldName: 'gamemode',
      value: 0,
      description: gamemodeDesc.i18n,
      selectables: {
        ServerPropertyGamemode.survival.index:
            ServerPropertyGamemode.survival.name,
        ServerPropertyGamemode.creative.index:
            ServerPropertyGamemode.creative.name,
        ServerPropertyGamemode.adventure.index:
            ServerPropertyGamemode.adventure.name,
        ServerPropertyGamemode.spectator.index:
            ServerPropertyGamemode.spectator.name,
      },
    ),
    BoolServerProperty(
      name: generateStructures.i18n,
      fieldName: 'generate-structures',
      value: true,
      description: generateStructuresDesc.i18n,
    ),
    StringServerProperty(
      name: generatorSettings.i18n,
      fieldName: 'generator-settings',
      value: '',
      description: generatorSettingsDesc.i18n,
    ),
    BoolServerProperty(
      name: hardcore.i18n,
      fieldName: 'hardcore',
      value: false,
      description: hardcoreDesc.i18n,
    ),
    StringServerProperty(
      name: levelName.i18n,
      fieldName: 'level-name',
      value: 'world',
      description: levelNameDesc.i18n,
    ),
    StringServerProperty(
      name: levelSeed.i18n,
      fieldName: 'level-seed',
      value: '',
      description: levelSeedDesc.i18n,
    ),
    // * enum
    // default - Standard world with hills, valleys, water, etc.
    // flat - A flat world with no features, can be modified with generator-settings.
    // largebiomes - Same as default but all biomes are larger.
    // amplified - Same as default but world-generation height limit is increased.
    // buffet - Same as default unless generator-settings is set to a preset.
    StringServerProperty(
      name: levelType.i18n,
      fieldName: 'level-type',
      value: 'default',
      description: levelTypeDesc.i18n,
    ),
    IntegerServerProperty(
      name: maxBuildHeight.i18n,
      fieldName: 'max-build-height',
      value: 256,
      description: maxBuildHeightDesc.i18n,
    ),
    IntegerServerProperty(
      name: maxPlayers.i18n,
      fieldName: 'max-players',
      value: 20,
      description: maxPlayersDesc.i18n,
    ),
    IntegerServerProperty(
      name: maxTickTime.i18n,
      fieldName: 'max-tick-time',
      value: 60000,
      description: maxTickTimeDesc.i18n,
    ),
    IntegerServerProperty(
      name: maxWorldSize.i18n,
      fieldName: 'max-world-size',
      value: 29999984,
      description: maxWorldSizeDesc.i18n,
    ),
    StringServerProperty(
      name: motd.i18n,
      fieldName: 'motd',
      value: 'A Minecraft Server',
      description: motdDesc.i18n,
    ),
    IntegerServerProperty(
      name: networkCompressionThreshold.i18n,
      fieldName: 'network-compression-threshold',
      value: 256,
      description: networkCompressionThresholdDesc.i18n,
    ),
    BoolServerProperty(
      name: onlineMode.i18n,
      fieldName: 'online-mode',
      value: true,
      description: onlineModeDesc.i18n,
    ),
    IntegerServerProperty(
      name: opPermissionLevel.i18n,
      fieldName: 'op-permission-level',
      value: 4,
      description: opPermissionLevelDesc.i18n,
    ),
    IntegerServerProperty(
      name: playerIdleTimeout.i18n,
      fieldName: 'player-idle-timeout',
      value: 0,
      description: playerIdleTimeoutDesc.i18n,
    ),
    BoolServerProperty(
      name: preventProxyConnections.i18n,
      fieldName: 'prevent-proxy-connections',
      value: false,
      description: preventProxyConnectionsDesc.i18n,
    ),
    BoolServerProperty(
      name: pvp.i18n,
      fieldName: 'pvp',
      value: true,
      description: pvpDesc.i18n,
    ),
    IntegerServerProperty(
      name: queryPort.i18n,
      fieldName: 'query.port',
      value: 25565,
      description: queryPortDesc.i18n,
    ),
    StringServerProperty(
      name: rconPassword.i18n,
      fieldName: 'rcon.password',
      value: '',
      description: rconPasswordDesc.i18n,
    ),
    IntegerServerProperty(
      name: rconPort.i18n,
      fieldName: 'rcon.port',
      value: 25575,
      description: rconPortDesc.i18n,
    ),
    StringServerProperty(
      name: resourcePack.i18n,
      fieldName: 'resource-pack',
      value: '',
      description: resourcePackDesc.i18n,
    ),
    StringServerProperty(
      name: resourcePackSha1.i18n,
      fieldName: 'resource-pack-sha1',
      value: '',
      description: resourcePackSha1Desc.i18n,
    ),
    StringServerProperty(
      name: serverIp.i18n,
      fieldName: 'server-ip',
      value: '',
      description: serverIpDesc.i18n,
    ),
    IntegerServerProperty(
      name: serverPort.i18n,
      fieldName: 'server-port',
      value: 25565,
      description: serverPortDesc.i18n,
    ),
    BoolServerProperty(
      name: snooperEnabled.i18n,
      fieldName: 'snooper-enabled',
      value: true,
      description: snooperEnabledDesc.i18n,
    ),
    BoolServerProperty(
      name: spawnAnimals.i18n,
      fieldName: 'spawn-animals',
      value: true,
      description: spawnAnimalsDesc.i18n,
    ),
    BoolServerProperty(
      name: spawnMonsters.i18n,
      fieldName: 'spawn-monsters',
      value: true,
      description: spawnMonstersDesc.i18n,
    ),
    BoolServerProperty(
      name: spawnNpcs.i18n,
      fieldName: 'spawn-npcs',
      value: true,
      description: spawnNpcsDesc.i18n,
    ),
    IntegerServerProperty(
      name: spawnProtection.i18n,
      fieldName: 'spawn-protection',
      value: 16,
      description: spawnProtectionDesc.i18n,
    ),
    BoolServerProperty(
      name: useNativeTransport.i18n,
      fieldName: 'use-native-transport',
      value: true,
      description: useNativeTransportDesc.i18n,
    ),
    IntegerServerProperty(
      name: viewDistance.i18n,
      fieldName: 'view-distance',
      value: 10,
      description: viewDistanceDesc.i18n,
    ),
    BoolServerProperty(
      name: whiteList.i18n,
      fieldName: 'white-list',
      value: false,
      description: whiteListDesc.i18n,
    ),
    BoolServerProperty(
      name: enforceWhitelist.i18n,
      fieldName: 'enforce-whitelist',
      value: false,
      description: enforceWhitelistDesc.i18n,
    ),
  ];
}
