import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/minecraft_command.i18n.dart';

class MinecraftCommand {
  final String command;
  final String description;
  const MinecraftCommand({
    required this.command,
    required this.description,
  });
}

Iterable<MinecraftCommand> getMinecraftCommands() {
  return [
    MinecraftCommand(command: '/?', description: qhelpDesc.i18n),
    MinecraftCommand(command: '/ability', description: abilityDesc.i18n),
    MinecraftCommand(
      command: '/achievement',
      description: achievementDesc.i18n,
    ),
    MinecraftCommand(
      command: '/advancement <grant|revoke|test> <player>',
      description: achievementAdvDesc.i18n,
    ),
    MinecraftCommand(command: '/agent', description: agentDesc.i18n),
    MinecraftCommand(
      command: '/ban <player>',
      description: banDesc.i18n,
    ),
    MinecraftCommand(
      command: '/ban-ip <ip>',
      description: banDesc.i18n,
    ),
    MinecraftCommand(command: '/banlist', description: banListDesc.i18n),
    MinecraftCommand(
      command: '/blockdata',
      description: blockdataDesc.i18n,
    ),
    MinecraftCommand(command: '/bossbar', description: bossbarDesc.i18n),
    MinecraftCommand(
      command: '/broadcast',
      description: broadcastDesc.i18n,
    ),
    MinecraftCommand(
      command: '/classroommode',
      description: classroomDesc.i18n,
    ),
    MinecraftCommand(
      command: '/clear [user] [item] [data] [maxCount] [dataTag]',
      description: clearDesc.i18n,
    ),
    MinecraftCommand(command: '/clone', description: cloneDesc.i18n),
    MinecraftCommand(
      command: '/closewebsocket',
      description: closewebsocketDesc.i18n,
    ),
    MinecraftCommand(command: '/connect', description: connectDesc.i18n),
    MinecraftCommand(command: '/data', description: dataDesc.i18n),
    MinecraftCommand(command: '/datapack', description: datapackDesc.i18n),
    MinecraftCommand(command: '/debug', description: debugDesc.i18n),
    MinecraftCommand(
      command: '/defaultgamemode <mode>',
      description: defaultgamemodeDesc.i18n,
    ),
    MinecraftCommand(command: '/deop <player>', description: deopDesc.i18n),
    MinecraftCommand(
      command: '/difficulty <level>',
      description: difficultyDesc.i18n,
    ),
    MinecraftCommand(
      command: '/effect <player> <effect id> [seconds] [amplifier]',
      description: effectDesc.i18n,
    ),
    MinecraftCommand(
      command: '/enableencryption',
      description: enableencryptionDesc.i18n,
    ),
    MinecraftCommand(
      command: '/enchant <user> <enchantment ID> <level> [force]',
      description: enchantDesc.i18n,
    ),
    MinecraftCommand(command: '/entitydata', description: entitydataDesc.i18n),
    MinecraftCommand(command: '/execute', description: executeDesc.i18n),
    MinecraftCommand(command: '/experience', description: experienceDesc.i18n),
    MinecraftCommand(command: '/fill', description: fillDesc.i18n),
    MinecraftCommand(command: '/forceload', description: forceloadDesc.i18n),
    MinecraftCommand(command: '/function', description: functionDesc.i18n),
    MinecraftCommand(
      command: '/gamemode <mode> [player]',
      description: gamemodeDesc.i18n,
    ),
    MinecraftCommand(
      command: '/gamerule [rule] [new value]',
      description: gameruleDesc.i18n,
    ),
    MinecraftCommand(
      command: '/give <player> <name> [amount] [damage] [data tag]',
      description: giveDesc.i18n,
    ),
    MinecraftCommand(
      command: '/help [command]',
      description: helpDesc.i18n,
    ),
    MinecraftCommand(
      command: '/immutableworld',
      description: immutableworldDesc.i18n,
    ),
    MinecraftCommand(
      command: '/kick <player> [reason]',
      description: kickDesc.i18n,
    ),
    MinecraftCommand(command: '/kill', description: killDesc.i18n),
    MinecraftCommand(command: '/list', description: listDesc.i18n),
    MinecraftCommand(command: '/listd', description: listdDesc.i18n),
    MinecraftCommand(command: '/locate', description: locateDesc.i18n),
    MinecraftCommand(command: '/loot', description: lootDesc.i18n),
    MinecraftCommand(command: '/me <message>', description: meDesc.i18n),
    MinecraftCommand(command: '/mixer', description: mixerDesc.i18n),
    MinecraftCommand(command: '/mobevent', description: mobeventDesc.i18n),
    MinecraftCommand(command: '/msg', description: msgDesc.i18n),
    MinecraftCommand(command: '/op <player>', description: opDesc.i18n),
    MinecraftCommand(command: '/pardon <player>', description: pardonDesc.i18n),
    MinecraftCommand(
      command: '/pardon-ip <ip>',
      description: pardonIpDesc.i18n,
    ),
    MinecraftCommand(command: '/particle', description: particleDesc.i18n),
    MinecraftCommand(command: '/playsound', description: playsoundDesc.i18n),
    MinecraftCommand(command: '/publish', description: publishDesc.i18n),
    MinecraftCommand(
      command: '/querytarget',
      description: querytargetDesc.i18n,
    ),
    MinecraftCommand(command: '/recipe', description: recipeDesc.i18n),
    MinecraftCommand(command: '/reload', description: reloadDesc.i18n),
    MinecraftCommand(command: '/remove', description: removeDesc.i18n),
    MinecraftCommand(
      command: '/replaceitem',
      description: replaceitemDesc.i18n,
    ),
    MinecraftCommand(command: '/resupply', description: resupplyDesc.i18n),
    MinecraftCommand(command: '/save', description: saveDesc.i18n),
    MinecraftCommand(command: '/save-all', description: saveAllDesc.i18n),
    MinecraftCommand(command: '/save-off', description: saveOffDesc.i18n),
    MinecraftCommand(command: '/save-on', description: saveOnDesc.i18n),
    MinecraftCommand(command: '/say', description: sayDesc.i18n),
    MinecraftCommand(command: '/schedule', description: scheduleDesc.i18n),
    MinecraftCommand(
      command: '/scoreboard <objectives/players/teams> <...>',
      description: scoreboardDesc.i18n,
    ),
    MinecraftCommand(command: '/seed', description: seedDesc.i18n),
    MinecraftCommand(command: '/setblock', description: setblockDesc.i18n),
    MinecraftCommand(
      command: '/setidletimeout <Minutes until kick>',
      description: setidletimeoutDesc.i18n,
    ),
    MinecraftCommand(
      command: '/setmaxplayers',
      description: setmaxplayersDesc.i18n,
    ),
    MinecraftCommand(command: '/setspawn', description: setspawnDesc.i18n),
    MinecraftCommand(
      command: '/setworldspawn [x] [y] [z]',
      description: setworldspawnDesc.i18n,
    ),
    MinecraftCommand(command: '/solid', description: solidDesc.i18n),
    MinecraftCommand(
      command: '/spawnpoint [User] [x] [y] [z]',
      description: spawnpointDesc.i18n,
    ),
    MinecraftCommand(
      command: '/spreadplayers',
      description: spreadplayersDesc.i18n,
    ),
    MinecraftCommand(command: '/stats', description: statsDesc.i18n),
    MinecraftCommand(command: '/stop', description: stopDesc.i18n),
    MinecraftCommand(
      command: '/stopsound',
      description: stopsoundDesc.i18n,
    ),
    MinecraftCommand(
      command: '/summon <EntityName> [x] [y] [z] [dataTag]',
      description: summonDesc.i18n,
    ),
    MinecraftCommand(command: '/tag', description: tagDesc.i18n),
    MinecraftCommand(command: '/team', description: teamDesc.i18n),
    MinecraftCommand(command: '/teleport', description: teleportDesc.i18n),
    MinecraftCommand(command: '/teammsg', description: teammsgDesc.i18n),
    MinecraftCommand(
      command: '/tell <player> <message>',
      description: tellDesc.i18n,
    ),
    MinecraftCommand(
      command: '/tellraw <player> <JSON message>',
      description: tellrawDesc.i18n,
    ),
    MinecraftCommand(
      command: '/testfor <player> [dataTag]',
      description: testforDesc.i18n,
    ),
    MinecraftCommand(
      command: '/testforblock',
      description: testforblockDesc.i18n,
    ),
    MinecraftCommand(
      command: '/testforblocks',
      description: testforblocksDesc.i18n,
    ),
    MinecraftCommand(
      command: '/tickingarea',
      description: tickingareaDesc.i18n,
    ),
    MinecraftCommand(
      command: '/time <add/set> <amount>',
      description: timeDesc.i18n,
    ),
    MinecraftCommand(command: '/title', description: titleDesc.i18n),
    MinecraftCommand(
      command: '/toggledownfall',
      description: toggledownfallDesc.i18n,
    ),
    MinecraftCommand(
      command: '/tp <player1> <player2>',
      description: tpDesc.i18n,
    ),
    MinecraftCommand(
      command: '/transferserver',
      description: transferserverDesc.i18n,
    ),
    MinecraftCommand(command: '/trigger', description: triggerDesc.i18n),
    MinecraftCommand(command: '/unban', description: unbanDesc.i18n),
    MinecraftCommand(command: '/w', description: wDesc.i18n),
    MinecraftCommand(
      command: '/weather <weather>',
      description: weatherDesc.i18n,
    ),
    MinecraftCommand(
      command: '/whitelist on/off,add/remove <player>,list,reload',
      description: whitelistDesc.i18n,
    ),
    MinecraftCommand(
      command: '/worldborder',
      description: worldborderDesc.i18n,
    ),
    MinecraftCommand(
      command: '/worldbuilder',
      description: worldbuilderDesc.i18n,
    ),
    MinecraftCommand(command: '/wsserver', description: wsserverDesc.i18n),
    MinecraftCommand(
      command: '/xp <player> <amount>',
      description: xpDesc.i18n,
    ),
  ];
}
