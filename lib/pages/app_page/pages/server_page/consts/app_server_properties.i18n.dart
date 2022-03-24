import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const allowFlight = 'allow-flight';
const allowNether = 'allow-nether';
const broadcastRconToOps = 'broadcast-rcon-to-ops';
const broadcastConsoleToOps = 'broadcast-console-to-ops';
const difficulty = 'difficulty';
const enableCommandBlock = 'enable-command-block';
const enableQuery = 'enable-query';
const enableRcon = 'enable-rcon';
const forceGamemode = 'force-gamemode';
const functionPermissionLevel = 'function-permission-level';
const gamemode = 'gamemode';
const generateStructures = 'generate-structures';
const generatorSettings = 'generator-settings';
const hardcore = 'hardcore';
const levelName = 'level-name';
const levelSeed = 'level-seed';
const levelType = 'level-type';
const maxBuildHeight = 'max-build-height';
const maxPlayers = 'max-players';
const maxTickTime = 'max-tick-time';
const maxWorldSize = 'max-world-size';
const motd = 'motd';
const networkCompressionThreshold = 'network-compression-threshold';
const onlineMode = 'online-mode';
const opPermissionLevel = 'op-permission-level';
const playerIdleTimeout = 'player-idle-timeout';
const preventProxyConnections = 'prevent-proxy-connections';
const pvp = 'pvp';
const queryPort = 'query.port';
const rconPassword = 'rcon.password';
const rconPort = 'rcon.port';
const resourcePack = 'resource-pack';
const resourcePackSha1 = 'resource-pack-sha1';
const serverIp = 'server-ip';
const serverPort = 'server-port';
const snooperEnabled = 'snooper-enabled';
const spawnAnimals = 'spawn-animals';
const spawnMonsters = 'spawn-monsters';
const spawnNpcs = 'spawn-npcs';
const spawnProtection = 'spawn-protection';
const useNativeTransport = 'use-native-transport';
const viewDistance = 'view-distance';
const whiteList = 'white-list';
const enforceWhitelist = 'enforce-whitelist';

const allowFlightDesc = 'allow-flight-desc';
const allowNetherDesc = 'allow-nether-desc';
const broadcastRconToOpsDesc = 'broadcast-rcon-to-ops-desc';
const broadcastConsoleToOpsDesc = 'broadcast-console-to-ops-desc';
const difficultyDesc = 'difficulty-desc';
const enableCommandBlockDesc = 'enable-command-block-desc';
const enableQueryDesc = 'enable-query-desc';
const enableRconDesc = 'enable-rcon-desc';
const forceGamemodeDesc = 'force-gamemode-desc';
const functionPermissionLevelDesc = 'function-permission-level-desc';
const gamemodeDesc = 'gamemode-desc';
const generateStructuresDesc = 'generate-structures-desc';
const generatorSettingsDesc = 'generator-settings-desc';
const hardcoreDesc = 'hardcore-desc';
const levelNameDesc = 'level-name-desc';
const levelSeedDesc = 'level-seed-desc';
const levelTypeDesc = 'level-type-desc';
const maxBuildHeightDesc = 'max-build-height-desc';
const maxPlayersDesc = 'max-players-desc';
const maxTickTimeDesc = 'max-tick-time-desc';
const maxWorldSizeDesc = 'max-world-size-desc';
const motdDesc = 'motd-desc';
const networkCompressionThresholdDesc = 'network-compression-threshold-desc';
const onlineModeDesc = 'online-mode-desc';
const opPermissionLevelDesc = 'op-permission-level-desc';
const playerIdleTimeoutDesc = 'player-idle-timeout-desc';
const preventProxyConnectionsDesc = 'prevent-proxy-connections-desc';
const pvpDesc = 'pvp-desc';
const queryPortDesc = 'query.port-desc';
const rconPasswordDesc = 'rcon.password-desc';
const rconPortDesc = 'rcon.port-desc';
const resourcePackDesc = 'resource-pack-desc';
const resourcePackSha1Desc = 'resource-pack-sha1-desc';
const serverIpDesc = 'server-ip-desc';
const serverPortDesc = 'server-port-desc';
const snooperEnabledDesc = 'snooper-enabled-desc';
const spawnAnimalsDesc = 'spawn-animals-desc';
const spawnMonstersDesc = 'spawn-monsters-desc';
const spawnNpcsDesc = 'spawn-npcs-desc';
const spawnProtectionDesc = 'spawn-protection-desc';
const useNativeTransportDesc = 'use-native-transport-desc';
const viewDistanceDesc = 'view-distance-desc';
const whiteListDesc = 'white-list-desc';
const enforceWhitelistDesc = 'enforce-whitelist-desc';

const gameModeSurvival = 'gameModeSurvival';
const gameModeCreative = 'gameModeCreative';
const gameModeAdventure = 'gameModeAdventure';
const gameModeSpectator = 'gameModeSpectator';
const difficultyPeaceful = 'difficultyPeaceful';
const difficultyEasy = 'difficultyEasy';
const difficultyNormal = 'difficultyNormal';
const difficultyHard = 'difficultyHard';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      allowFlight: {
        AppLocalization.enUS.name: 'allow-flight',
        AppLocalization.zhTW.name: '允許飛行',
      },
      allowFlightDesc: {
        AppLocalization.enUS.name: '''
Allows users to use flight on your server while in Survival mode, if they have a mod that provides flight installed.

With allow-flight enabled, griefers may become more common, because it makes their work easier. In Creative mode this has no effect.

false - Flight is not allowed (players in air for at least 5 seconds get kicked).
true - Flight is allowed, and used if the player has a fly mod installed.
''',
        AppLocalization.zhTW.name: '''
允許玩家在安裝添加飛行功能的 mod 前提下在生存模式下飛行。

允許飛行可能會使惡意破壞者更加常見，因為此設定會使他們更容易達成目的。在創造模式下無作用。

false - 不允許飛行。懸空超過5秒的玩家會被踢出伺服器。
true - 允許飛行。玩家得以使用飛行 mod 飛行。
''',
      },
      allowNether: {
        AppLocalization.enUS.name: 'allow-nether',
        AppLocalization.zhTW.name: '允許地獄',
      },
      allowNetherDesc: {
        AppLocalization.enUS.name: '''
Allows players to travel to the Nether.
false - Nether portals will not work.
true - The server allows portals to send players to the Nether.
''',
        AppLocalization.zhTW.name: '''
允許玩家進入地獄。
false - 地獄傳送門不會生效。
true - 玩家可以通過地獄傳送門前往地獄。
''',
      },
      broadcastRconToOps: {
        AppLocalization.enUS.name: 'broadcast-rcon-to-ops',
        AppLocalization.zhTW.name: '廣播遠端訊息',
      },
      broadcastRconToOpsDesc: {
        AppLocalization.enUS.name: '''
Allow ops to broadcast message when someone use Minecraft RCON to control terminal remotely.

false - RCON Connection broadcasting is not allowed.
true - RCON Connection broadcasting is allowed.
''',
        AppLocalization.zhTW.name: '''
允許廣播經由 Minecraft RCON 客戶端控制終端機時顯示訊息給所有 ops

false - 不允許 RCON 遠端終端機控制時顯示。
true - 允許 RCON 遠端終端機控制時顯示。
''',
      },
      broadcastConsoleToOps: {
        AppLocalization.enUS.name: 'broadcast-console-to-ops',
        AppLocalization.zhTW.name: '廣播終端訊息',
      },
      broadcastConsoleToOpsDesc: {
        AppLocalization.enUS.name: '''
Allow ops on the server to receive a message whenever a command is sent

false - Disallow broadcast, Only the op who sent the command received.
true - Allow broadcase, all op receive message whenever a command is sent.
''',
        AppLocalization.zhTW.name: '''
允許所有 OP 玩家收到所有指令消息

false - 不允許廣播消息，只有發送者 OP 收到。
true - 允許廣播消息，所有 OP 將收到所有消息。
''',
      },
      difficulty: {
        AppLocalization.enUS.name: 'difficulty',
        AppLocalization.zhTW.name: '難度',
      },
      difficultyDesc: {
        AppLocalization.enUS.name: '''
Defines the difficulty (such as damage dealt by mobs and the way hunger and poison affects players) of the server.

If a legacy difficulty number is specified, it is silently converted to a difficulty name.

peaceful (0)
easy (1)
normal (2)
hard (3)
''',
        AppLocalization.zhTW.name: '''
定義伺服器的遊戲難易度（例如生物對玩家造成的傷害，飢餓和中毒對玩家的影響方式等）。

如果設定了舊的數字ID，則會自動轉化為英文的難易度名稱。

peaceful (0) - 和平
easy (1) - 簡單
normal (2) - 普通
hard (3) - 困難
''',
      },
      enableCommandBlock: {
        AppLocalization.enUS.name: 'enable-command-block',
        AppLocalization.zhTW.name: '允許命令方塊',
      },
      enableCommandBlockDesc: {
        AppLocalization.enUS.name: '''
Enables command blocks
''',
        AppLocalization.zhTW.name: '''
是否啟用指令方塊
''',
      },
      enableQuery: {
        AppLocalization.enUS.name: 'enable-query',
        AppLocalization.zhTW.name: '允許查詢',
      },
      enableQueryDesc: {
        AppLocalization.enUS.name: '''
Enables GameSpy4 protocol server listener. Used to get information about server.
''',
        AppLocalization.zhTW.name: '''
允許使用 GameSpy4 協議的伺服器監聽器。用於獲取伺服器信息。
''',
      },
      enableRcon: {
        AppLocalization.enUS.name: 'enable-rcon',
        AppLocalization.zhTW.name: '允許遠端控制',
      },
      enableRconDesc: {
        AppLocalization.enUS.name: '''
Enables remote access to the server console.
''',
        AppLocalization.zhTW.name: '''
是否允許遠程訪問伺服器控制台。
''',
      },
      forceGamemode: {
        AppLocalization.enUS.name: 'force-gamemode',
        AppLocalization.zhTW.name: '強制遊玩模式',
      },
      forceGamemodeDesc: {
        AppLocalization.enUS.name: '''
Force players to join in the default game mode.
false - Players will join in the gamemode they left in.
true - Players will always join in the default gamemode.
''',
        AppLocalization.zhTW.name: '''
強制玩家加入時為預設遊戲模式。
false - 玩家將以退出前的遊戲模式加入
true - 玩家總是以預設遊戲模式加入
''',
      },
      functionPermissionLevel: {
        AppLocalization.enUS.name: 'function-permission-level',
        AppLocalization.zhTW.name: '指令權限',
      },
      functionPermissionLevelDesc: {
        AppLocalization.enUS.name: '''
Sets the default permission level for functions.

See #op-permission-level for the details on the 4 levels.
''',
        AppLocalization.zhTW.name: '''
設定函數的預設權限等級。

4 個等級的詳情見 #op-permission-level。
''',
      },
      gamemode: {
        AppLocalization.enUS.name: 'gamemode',
        AppLocalization.zhTW.name: '遊玩模式',
      },
      gamemodeDesc: {
        AppLocalization.enUS.name: '''
Defines the mode of gameplay.

If a legacy gamemode number is specified, it is silently converted to a gamemode name.

survival (0)
creative (1)
adventure (2)
spectator (3)
''',
        AppLocalization.zhTW.name: '''
定義預設遊戲模式。

如果值是舊用的數字，會靜默轉換為對應遊戲模式的英文名稱。

survival (0) - 生存模式
creative (1) - 創造模式
adventure (2) - 冒險模式
spectator (3) - 旁觀者模式
''',
      },
      generateStructures: {
        AppLocalization.enUS.name: 'generate-structures',
        AppLocalization.zhTW.name: '生成建築',
      },
      generateStructuresDesc: {
        AppLocalization.enUS.name: '''
Defines whether structures (such as villages) can be generated.
false - Structures will not be generated in new chunks.
true - Structures will be generated in new chunks.

Note: Dungeons still generate if this is set to false.
''',
        AppLocalization.zhTW.name: '''
定義是否能生成結構（例如村莊）。
false - 新生成的區塊中將不包含結構。
true - 新生成的區塊中將包含結構。

註： 即使設為 false，地牢仍然會生成。
''',
      },
      generatorSettings: {
        AppLocalization.enUS.name: 'generator-settings',
        AppLocalization.zhTW.name: '生成設定',
      },
      generatorSettingsDesc: {
        AppLocalization.enUS.name: '''
The settings used to customize world generation. See Superflat and Customized for possible settings and examples.
''',
        AppLocalization.zhTW.name: '''
本屬性質用於自定義世界的生成。詳見超平坦世界和自定義了解正確的設定及例子。
''',
      },
      hardcore: {
        AppLocalization.enUS.name: 'hardcore',
        AppLocalization.zhTW.name: '極限',
      },
      hardcoreDesc: {
        AppLocalization.enUS.name: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
        AppLocalization.zhTW.name: '''
如果設為 true，伺服器難易度的設定會被忽略並且設為 hard（困難），玩家在死後會自動切換至旁觀者模式。
''',
      },
      levelName: {
        AppLocalization.enUS.name: 'level-name',
        AppLocalization.zhTW.name: '地圖名稱',
      },
      levelNameDesc: {
        AppLocalization.enUS.name: '''
The 'level-name' value is used as the world name and its folder name. You may also copy your saved game folder here, and change the name to the same as that folder's to load it instead.
Characters such as ' (apostrophe) may need to be escaped by adding a backslash before them.
''',
        AppLocalization.zhTW.name: '''
「level-name」的值將作為世界名稱及其資料夾名。你也可以把你已生成的世界存檔複製過來，然後讓這個值與那個資料夾的名字保持一致，伺服器就可以載入該存檔。
部分字符，例如 ' （單引號）可能需要在前面加反斜槓號  才能被正常應用。
''',
      },
      levelSeed: {
        AppLocalization.enUS.name: 'level-seed',
        AppLocalization.zhTW.name: '地圖種子',
      },
      levelSeedDesc: {
        AppLocalization.enUS.name: '''
Add a seed for your world, as in Singleplayer.
Some examples are: minecraft, 404, 1a2b3c.
''',
        AppLocalization.zhTW.name: '''
與單人遊戲類似，為你的世界定義一個種子。
這裡有一些例子：minecraft，404，1a2b3c。
''',
      },
      levelType: {
        AppLocalization.enUS.name: 'level-type',
        AppLocalization.zhTW.name: '地圖種類',
      },
      levelTypeDesc: {
        AppLocalization.enUS.name: '''
Determines the type of map that is generated.
default - Standard world with hills, valleys, water, etc.
flat - A flat world with no features, can be modified with generator-settings.
largebiomes - Same as default but all biomes are larger.
amplified - Same as default but world-generation height limit is increased.
buffet - Same as default unless generator-settings is set to a preset.
''',
        AppLocalization.zhTW.name: '''
確定地圖所生成的類型
default - 帶有丘陵，河谷，海洋等的標準的世界。
flat - 一個沒有特性的平坦世界，可用 generator-settings 修改。
largebiomes - 如同方案（default）世界，但所有生態域都更大。
amplified - 如同方案世界，但世界生成高度提高。
buffet - 如同方案世界，但 generator-settings 設定後不同。
''',
      },
      maxBuildHeight: {
        AppLocalization.enUS.name: 'max-build-height',
        AppLocalization.zhTW.name: '高度最大上限',
      },
      maxBuildHeightDesc: {
        AppLocalization.enUS.name: '''
The maximum height in which building is allowed. Terrain may still naturally generate above a low height limit.
''',
        AppLocalization.zhTW.name: '''
玩家在遊戲中能夠建造的最大高度。可能會在該值較小時生成超過該值的地形。
''',
      },
      maxPlayers: {
        AppLocalization.enUS.name: 'max-players',
        AppLocalization.zhTW.name: '玩家最大人數',
      },
      maxPlayersDesc: {
        AppLocalization.enUS.name: '''
The maximum number of players that can play on the server at the same time. Note that more players on the server consume more resources. Note also, op player connections are not supposed to count against the max players, but ops currently cannot join a full server. However, this can be changed by going to the file called ops.json in your server directory, opening it, finding the op you want the change, and changing the setting called bypassesPlayerLimit to true (the default is false). This means that that op does not have to wait for a player to leave in order to join. Extremely large values for this field result in the client-side user list being broken.
''',
        AppLocalization.zhTW.name: '''
伺服器同時能容納的最大玩家數量。請注意，在線玩家越多，對伺服器造成的負擔也就越大。同樣注意，伺服器的OP具有在人滿的情況下強行進入伺服器的能力：找到在伺服器根目錄下叫 ops.json 的文件並打開，將需要此能力的OP下的 bypassesPlayerLimit 選項設定為 true 即可（預設值為 false），這意味著OP將不需要在伺服器人滿時等待有玩家離開後再加入。過大的數值會使客戶端顯示的玩家列表崩壞。
''',
      },
      maxTickTime: {
        AppLocalization.enUS.name: 'max-tick-time',
        AppLocalization.zhTW.name: '最大監測時間',
      },
      maxTickTimeDesc: {
        AppLocalization.enUS.name: '''
The maximum number of milliseconds a single tick may take before the server watchdog stops the server with the message, A single server tick took 60.00 seconds (should be max 0.05); Considering it to be crashed, server will forcibly shutdown. Once this criterion is met, it calls System.exit(1).
-1 - disable watchdog entirely (this disable option was added in 14w32a)
''',
        AppLocalization.zhTW.name: '''
設定每個 tick 花費的最大毫秒數。超過該毫秒數時，伺服器看門狗將停止伺服器程序並附帶上信息：伺服器的一個 tick 花費了60.00秒（最長也應該只有0.05秒）；判定伺服器已崩潰，它將被強制關閉。遇到這種情況的時候，它會調用 System.exit(1)。

譯者註：如果你監測服務程序的返回代碼，此時返回代碼會為1。（習慣上，程序正常退出應當返回0）

-1 - 完全停用看門狗（這個停用選項在 14w32a 快照中添加）
''',
      },
      maxWorldSize: {
        AppLocalization.enUS.name: 'max-world-size',
        AppLocalization.zhTW.name: '地圖最大規模',
      },
      maxWorldSizeDesc: {
        AppLocalization.enUS.name: '''
This sets the maximum possible size in blocks, expressed as a radius, that the world border can obtain. Setting the world border bigger causes the commands to complete successfully but the actual border does not move past this block limit. Setting the max-world-size higher than the default doesn't appear to do anything.

Examples:

Setting max-world-size to 1000 allows you to have a 2000×2000 world border.
Setting max-world-size to 4000 gives you an 8000×8000 world border.
''',
        AppLocalization.zhTW.name: '''
設定可讓世界邊界獲得的最大半徑值，單位為方塊。通過成功執行的指令能把世界邊界設定得更大，但不會超過這裡設定的最大方塊限制。如果設定的 max-world-size 超過預設值的大小，那將不會起任何效果。

例如：

設定 max-world-size 為 1000 將會有 2000x2000 的地圖邊界。
設定 max-world-size 為 4000 將會有 8000x8000 的地圖邊界。
''',
      },
      motd: {
        AppLocalization.enUS.name: 'motd',
        AppLocalization.zhTW.name: '伺服器描述',
      },
      motdDesc: {
        AppLocalization.enUS.name: '''
This is the message that is displayed in the server list of the client, below the name.
The MOTD supports color and formatting codes.
The MOTD supports special characters, such as '♥'. However, such characters must be converted to escaped Unicode form. An online converter can be found here.
If the MOTD is over 59 characters, the server list will likely report a communication error.
''',
        AppLocalization.zhTW.name: '''
本屬性值是玩家客戶端的多人遊戲伺服器列表中顯示的伺服器信息，顯示於名稱下方。
MOTD 支持樣式代碼。
MOTD 支持特殊符號，比如 '♥'。然而，這些符號需要轉換為 Unicode 轉義字符。你可以在這裡找到一個轉換器。
如果 MOTD 超過59個字符，伺服器列表很可能會返回「通訊錯誤」。
''',
      },
      networkCompressionThreshold: {
        AppLocalization.enUS.name: 'network-compression-threshold',
        AppLocalization.zhTW.name: '傳輸壓縮閥',
      },
      networkCompressionThresholdDesc: {
        AppLocalization.enUS.name: '''
By default it allows packets that are n-1 bytes big to go normally, but a packet of n bytes or more will be compressed down. So, a lower number means more compression but compressing small amounts of bytes might actually end up with a larger result than what went in.
-1 - disable compression entirely
0 - compress everything

Note: The Ethernet spec requires that packets less than 64 bytes become padded to 64 bytes. Thus, setting a value lower than 64 may not be beneficial. It is also not recommended to exceed the MTU, typically 1500 bytes.
''',
        AppLocalization.zhTW.name: '''
預設會允許 n-1 字節的資料包正常發送, 如果資料包為 n 字節或更大時會進行壓縮。所以，更低的數值會使得更多的資料包被壓縮，但是如果被壓縮的資料包字節太小將反而使壓縮後字節更大。
-1 - 完全禁用資料包壓縮
0 - 壓縮全部資料包

注: 乙太網規範要求把小於64位元組的資料包填充為64位元組。因此，設定一個低於64的值可能沒有什麼好處。也不推薦讓設定的值超過MTU（通常為1500位元組）。
'''
      },
      onlineMode: {
        AppLocalization.enUS.name: 'online-mode',
        AppLocalization.zhTW.name: '線上驗證',
      },
      onlineModeDesc: {
        AppLocalization.enUS.name: '''
Server checks connecting players against Minecraft account database. Only set this to false if your server is not connected to the Internet. Hackers with fake accounts can connect if this is set to false! If minecraft.net is down or inaccessible, no players can connect if this is set to true. Setting this variable to off purposely is called 'cracking' a server, and servers that are presently with online mode off are called 'cracked' servers, allowing players with unlicensed copies of Minecraft to join.
true - Enabled. The server will assume it has an Internet connection and checks every connecting player.
false - Disabled. The server will not attempt to check connecting players.
''',
        AppLocalization.zhTW.name: '''
是否讓伺服器對比 Minecraft 帳戶資料庫驗證登錄信息。只有在你的伺服器並未與 Internet 連接時，才將這個值設為 false。如果設為 false，黑客就能夠使用任意假帳戶連接伺服器！如果 minecraft.net 伺服器宕機或不可訪問，那麼該值設為 true 的伺服器會因為無法驗證玩家身份而拒絕所有玩家加入。通常，這個值設為 true 的伺服器被稱為「正版伺服器」。故意設定該變量為 false 的伺服器稱為「破解伺服器」，這類伺服器允許擁有未授權的 Minecraft 副本的玩家加入。
true - 啟用。伺服器會認為自己具有 Internet 連接，並檢查每一位連入的玩家。
false - 禁用。伺服器不會嘗試檢查玩家。
''',
      },
      opPermissionLevel: {
        AppLocalization.enUS.name: 'op-permission-level',
        AppLocalization.zhTW.name: '管理員等級',
      },
      opPermissionLevelDesc: {
        AppLocalization.enUS.name: '''
Sets the default permission level for ops when using /op. All levels inherit abilities and commands from levels before them.
1 - Ops can bypass spawn protection.
2 - Ops can use all singleplayer cheats commands (except /publish, as it is not on servers; along with /debug) and use command blocks. Command blocks, along with Realms owners/operators, have the same permissions as this level.
3 - Ops can use most multiplayer-exclusive commands, including /debug, and commands that manage players (/ban, /op, etc).
4 - Ops can use all commands including /stop, /save-all, /save-on, and /save-off.
''',
        AppLocalization.zhTW.name: '''
設定使用/op指令時OP的權限等級。所有存檔會從之前的存檔繼承能力和指令。
1 - OP可以繞過重生點保護。
2 - OP可以使用所有單人遊戲作弊指令（除了 /publish，因為不能在伺服器上使用；/debug 也是）並使用指令方塊。指令方塊和領域服服主/管理員有此等級權限。
3 - OP可以使用大多數多人遊戲中獨有的指令，包括 /debug，以及管理玩家的指令（/ban, /op 等等）。
4 - OP可以使用所有指令，包括 /stop, /save-all, /save-on 和 /save-off。
''',
      },
      playerIdleTimeout: {
        AppLocalization.enUS.name: 'player-idle-timeout',
        AppLocalization.zhTW.name: '玩家閒置時間',
      },
      playerIdleTimeoutDesc: {
        AppLocalization.enUS.name: '''
If non-zero, players are kicked from the server if they are idle for more than that many minutes.
Note: Idle time is reset when the server receives one of the following packets:
Click Window
Enchant Item
Update Sign
Player Digging
Player Block Placement
Held Item Change
Animation (swing arm)
Entity Action
Client Status
Chat Message
Use Entity
''',
        AppLocalization.zhTW.name: '''
如果不為0，伺服器將在玩家的空閒時間達到設定的時間（單位為分鐘）時將玩家踢出伺服器
註： 當伺服器接受到下列資料包之一時將會重置空閒時間：
點擊窗口
附魔物品
更新告示牌
玩家挖掘方塊
玩家放置方塊
更換拿著的物品
動畫 (揮動手臂)
實體動作
客戶端狀態
聊天信息
使用實體
''',
      },
      preventProxyConnections: {
        AppLocalization.enUS.name: 'prevent-proxy-connections',
        AppLocalization.zhTW.name: '禁止代理連線',
      },
      preventProxyConnectionsDesc: {
        AppLocalization.enUS.name: '''
If the ISP/AS sent from the server is different from the one from Mojang's authentication server, the player is kicked
true - Enabled. Server prevents users from using vpns or proxies.
false - Disabled. The server doesn't prevent users from using vpns or proxies.
''',
        AppLocalization.zhTW.name: '''
如果伺服器發送的 ISP/AS 和 Mojang 的驗證伺服器的不一樣，玩家將會被踢出。
true - 啟用。伺服器將會禁止玩家使用虛擬專用網絡或代理。
false - 禁用。伺服器將不會禁止玩家使用虛擬專用網絡或代理。
''',
      },
      pvp: {
        AppLocalization.enUS.name: 'pvp',
        AppLocalization.zhTW.name: 'PVP',
      },
      pvpDesc: {
        AppLocalization.enUS.name: '''
Enable PvP on the server. Players shooting themselves with arrows receive damage only if PvP is enabled.
true - Players can kill each other.
false - Players cannot kill other players (also known as Player versus Environment (PvE)).

Note: Indirect damage sources spawned by players (such as lava, fire, TNT and to some extent water, sand and gravel) still deal damage to other players.
''',
        AppLocalization.zhTW.name: '''
是否允許 PvP。也只有在允許 PvP 時玩家自己的箭才會受到傷害。
true - 玩家可以互相殘殺。
false - 玩家無法互相造成傷害（也稱作玩家對戰環境 (PvE)）。

註： 由玩家造成的間接傷害（例如熔岩，火，TNT等，某種程度上還有水，沙和礫石）還是會傷害其他玩家。



''',
      },
      queryPort: {
        AppLocalization.enUS.name: 'query.port',
        AppLocalization.zhTW.name: '監聽埠',
      },
      queryPortDesc: {
        AppLocalization.enUS.name: '''
Sets the port for the query server (see enable-query).
''',
        AppLocalization.zhTW.name: '''
設定監聽伺服器的埠號（參見 enable-query）。
''',
      },
      rconPassword: {
        AppLocalization.enUS.name: 'rcon.password',
        AppLocalization.zhTW.name: 'RCON 遠端密碼',
      },
      rconPasswordDesc: {
        AppLocalization.enUS.name: '''
Sets the password for RCON: a remote console protocol that can allow other applications to connect and interact with a Minecraft server over the internet.
''',
        AppLocalization.zhTW.name: '''
設定 RCON 遠程訪問的密碼（參見enable-rcon）。RCON：能允許其他應用程式通過網際網路與 Minecraft 伺服器連接並交互的遠程控制台協議。
''',
      },
      rconPort: {
        AppLocalization.enUS.name: 'rcon.port',
        AppLocalization.zhTW.name: 'RCON 遠端埠',
      },
      rconPortDesc: {
        AppLocalization.enUS.name: '''
Sets the RCON network port.
''',
        AppLocalization.zhTW.name: '''
設定 RCON 遠程訪問的埠號。
''',
      },
      resourcePack: {
        AppLocalization.enUS.name: 'resource-pack',
        AppLocalization.zhTW.name: '資源包連結',
      },
      resourcePackDesc: {
        AppLocalization.enUS.name: '''
Optional URI to a resource pack. The player may choose to use it.

Note that the ':' and '=' characters need to be escaped with backslash (), e.g. http://somedomain.com/somepack.zip?someparam=somevalue

The resource pack may not have a larger file size than 50 MiB (≈ 50.4 MB). Note that download success or failure is logged by the client, and not by the server.
''',
        AppLocalization.zhTW.name: '''
可選選項，可輸入指向一個資源包的 URI。玩家可選擇是否使用該資源包。

注意若該值含 ':' 和 '=' 字符，需要在其前加上反斜線(\\)，例如 http\\://somedomain.com/somepack.zip?someparam\\=somevalue

資源包大小理應不能超過 50 MiB (≈ 50.4 MB)。注意，下載成功或失敗由客戶端記錄，而非伺服器。'''
      },
      resourcePackSha1: {
        AppLocalization.enUS.name: 'resource-pack-sha1',
        AppLocalization.zhTW.name: '資源包驗證值',
      },
      resourcePackSha1Desc: {
        AppLocalization.enUS.name: '''
Optional SHA-1 digest of the resource pack, in lowercase hexadecimal. It's recommended to specify this. This is not yet used to verify the integrity of the resource pack, but improves the effectiveness and reliability of caching.
''',
        AppLocalization.zhTW.name: '''
資源包的 SHA-1 值，必須為小寫十六進位，建議填寫它。這還沒有用於驗證資源包的完整性，但是它提高了資源包緩存的有效性和可靠性。
''',
      },
      serverIp: {
        AppLocalization.enUS.name: 'server-ip',
        AppLocalization.zhTW.name: '伺服器 IP',
      },
      serverIpDesc: {
        AppLocalization.enUS.name: '''
Set this if you want the server to bind to a particular IP. It is strongly recommended that you leave server-ip blank!
Set to blank, or the IP you want your server to run (listen) on.
''',
        AppLocalization.zhTW.name: '''
將伺服器與一個特定IP綁定。強烈建議留空該屬性值！
留空，或是填入你想讓伺服器綁定（監聽）的IP。
''',
      },
      serverPort: {
        AppLocalization.enUS.name: 'server-port',
        AppLocalization.zhTW.name: '伺服器埠',
      },
      serverPortDesc: {
        AppLocalization.enUS.name: '''
Notice: Please use 25565, because Minecraft Scepter only accpeted this value. Other value should take care yourself.
Changes the port the server is hosting (listening) on. This port must be forwarded if the server is hosted in a network using NAT (If you have a home router/firewall).
''',
        AppLocalization.zhTW.name: '''
注意，請使用 25565，當前權杖只接受這個數值。若使用其他數值，請自行承擔操作問題。
改變伺服器（監聽的）埠號。如果伺服器在使用NAT的網絡中運行，該埠必須被轉發（在你有家用路由器/抗火牆的前提下）。
''',
      },
      snooperEnabled: {
        AppLocalization.enUS.name: 'snooper-enabled',
        AppLocalization.zhTW.name: '數據採集',
      },
      snooperEnabledDesc: {
        AppLocalization.enUS.name: '''
Sets whether the server sends snoop data regularly to http://snoop.minecraft.net.
false - disable snooping.
true - enable snooping.
''',
        AppLocalization.zhTW.name: '''
是否允許服務端定期發送統計數據到 http://snoop.minecraft.net。
false - 禁用數據採集
true - 啟用數據採集'''
      },
      spawnAnimals: {
        AppLocalization.enUS.name: 'spawn-animals',
        AppLocalization.zhTW.name: '生成動物',
      },
      spawnAnimalsDesc: {
        AppLocalization.enUS.name: '''
Determines if animals can spawn.
true - Animals spawn as normal.
false - Animals immediately vanish.

Tip: if you have major lag, turn this off/set to false.
''',
        AppLocalization.zhTW.name: '''
決定動物是否可以生成。
true - 動物可以正常生成。
false - 動物生成後會立即消失。

提示：如果你有嚴重的卡頓，可以設為 false。
''',
      },
      spawnMonsters: {
        AppLocalization.enUS.name: 'spawn-monsters',
        AppLocalization.zhTW.name: '生成怪物',
      },
      spawnMonstersDesc: {
        AppLocalization.enUS.name: '''
Determines if monsters can spawn.
true - Enabled. Monsters will appear at night and in the dark.
false - Disabled. No monsters.

This setting has no effect if difficulty = 0 (peaceful). If difficulty is not = 0, a monster can still spawn from a Monster Spawner.

Tip: if you have major lag, turn this off/set to false.
''',
        AppLocalization.zhTW.name: '''
決定攻擊型生物（怪物）是否可以生成。
true - 啟用。怪物會生成於夜晚和黑暗處。
false - 禁用。不會有任何怪物。

如果 difficulty = 0 (peaceful)（即難易度設定為和平）的話，該屬性值不會有任何影響。

提示：如果你有嚴重的卡頓，可以設為 false。
''',
      },
      spawnNpcs: {
        AppLocalization.enUS.name: 'spawn-npcs',
        AppLocalization.zhTW.name: '生成 NPC',
      },
      spawnNpcsDesc: {
        AppLocalization.enUS.name: '''
Determines whether villagers can spawn.
true - Enabled. Villagers will spawn.
false - Disabled. No villagers.
''',
        AppLocalization.zhTW.name: '''
決定是否生成村民。
true - 啟用。生成村民。
false - 禁用。不會有村民。
''',
      },
      spawnProtection: {
        AppLocalization.enUS.name: 'spawn-protection',
        AppLocalization.zhTW.name: '出生保護區',
      },
      spawnProtectionDesc: {
        AppLocalization.enUS.name: '''
Determines the radius of the spawn protection as 2x+1. Setting this to 0 does not disable spawn protection, but protects the single block at the spawn point. 1 protects a 3×3 area centered on the spawn point. 2 protects 5×5, 3 protects 7×7, etc. This option is not generated on the first server start and appears when the first player joins. If there are no ops set on the server, the spawn protection is disabled automatically.
''',
        AppLocalization.zhTW.name: '''
通過將該值進行 2x+1 的運算來決定出生點的保護半徑。設定為0將不會禁用出生點保護，但會保護位於出生點的那一個方塊。設定為1會保護以出生點為中心的3x3方塊的區域，2會保護5x5方塊的區域，3會保護7x7方塊的區域，以此類推。這個選項不在第一次伺服器啟動時生成，只會在第一個玩家加入伺服器時出現。如果伺服器沒有設定OP，這個選項會自動禁用。
''',
      },
      useNativeTransport: {
        AppLocalization.enUS.name: 'use-native-transport',
        AppLocalization.zhTW.name: '優化傳輸',
      },
      useNativeTransportDesc: {
        AppLocalization.enUS.name: '''
Linux server performance improvements: optimized packet sending/receiving on Linux
true - Enabled. Enable Linux packet sending/receiving optimization
false - Disabled. Disable Linux packet sending/receiving optimization
''',
        AppLocalization.zhTW.name: '''
是否使用針對 Linux 平台的資料包收發優化。此選項僅會在 Linux 平台上生成。
true - 啟用。啟用 Linux 資料包收發優化。
false - 禁用。禁用 Linux 資料包收發優化。
''',
      },
      viewDistance: {
        AppLocalization.enUS.name: 'view-distance',
        AppLocalization.zhTW.name: '視野',
      },
      viewDistanceDesc: {
        AppLocalization.enUS.name: '''
Sets the amount of world data the server sends the client, measured in chunks in each direction of the player (radius, not diameter). It determines the server-side viewing distance. (see Render distance)

10 is the default/recommended. If you have major lag, reduce this value.

Note: A value less than 9 has a big impact on mob spawning on the server, as noted in bug MC-2536.
''',
        AppLocalization.zhTW.name: '''
設定服務端發送給客戶端的世界數據量，也就是設定玩家各個方向上的區塊數量 (是以玩家為中心的半徑，不是直徑)。它決定了服務端的可視距離。(另見 視野距離)

預設/推薦設定為10，如果有嚴重卡頓的話，減少該數值。

注: 該值小於 9 時會對伺服器上的生物生成有顯著影響，詳見 bug MC-2536。 '''
      },
      whiteList: {
        AppLocalization.enUS.name: 'white-list',
        AppLocalization.zhTW.name: '白名單',
      },
      whiteListDesc: {
        AppLocalization.enUS.name: '''
Enables a whitelist on the server.

With a whitelist enabled, users not on the whitelist cannot connect. Intended for private servers, such as those for real-life friends or strangers carefully selected via an application process, for example.

false - No white list is used.
true - The file whitelist.json is used to generate the white list.

Note: Ops are automatically white listed, and there is no need to add them to the whitelist.
''',
        AppLocalization.zhTW.name: '''
啟用伺服器的白名單。

當啟用時，只有白名單上的用戶才能連接伺服器。白名單主要用於私人伺服器，例如提供給相識的朋友、通過應用流程謹慎選擇的陌生人等。

false - 不使用白名單。
true - 從 whitelist.json 文件加載白名單。

注: - OP會自動被視為在白名單上，所以無需再將OP加入白名單。 '''
      },
      enforceWhitelist: {
        AppLocalization.enUS.name: 'enforce-whitelist',
        AppLocalization.zhTW.name: '強制執行白名單',
      },
      enforceWhitelistDesc: {
        AppLocalization.enUS.name: '''
Enforces the whitelist on the server.

When this option is enabled, users who are not present on the whitelist (if it's enabled) get kicked from the server after the server reloads the whitelist file.

false - No user will be kicked if not on the whitelist.
true - Online users not on the whitelist will be kicked.
''',
        AppLocalization.zhTW.name: '''
在伺服器上強制執行白名單。

當啟用後，不在白名單（前提是啟用）中的用戶將在伺服器重新加載白名單文件後從伺服器踢出。

true - 不在白名單上的用戶不會被踢出。
false - 不在白名單上的在線用戶會被踢出。
''',
      },
      gameModeSurvival: {
        AppLocalization.enUS.name: 'Survival',
        AppLocalization.zhTW.name: '生存',
      },
      gameModeCreative: {
        AppLocalization.enUS.name: 'Creative',
        AppLocalization.zhTW.name: '創造',
      },
      gameModeAdventure: {
        AppLocalization.enUS.name: 'Adventure',
        AppLocalization.zhTW.name: '冒險',
      },
      gameModeSpectator: {
        AppLocalization.enUS.name: 'Spectator',
        AppLocalization.zhTW.name: '觀察者',
      },
      difficultyPeaceful: {
        AppLocalization.enUS.name: 'Peaceful',
        AppLocalization.zhTW.name: '和平',
      },
      difficultyEasy: {
        AppLocalization.enUS.name: 'Easy',
        AppLocalization.zhTW.name: '簡單',
      },
      difficultyNormal: {
        AppLocalization.enUS.name: 'Normal',
        AppLocalization.zhTW.name: '普通',
      },
      difficultyHard: {
        AppLocalization.enUS.name: 'Hard',
        AppLocalization.zhTW.name: '困難',
      },
    },
  );

  String get i18n => localize(this, _t);
}
