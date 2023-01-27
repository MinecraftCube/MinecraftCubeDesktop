import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

void main() {
  group('VanillaServerInfo', () {
    test('fromJson', () {
      final result =
          VanillaServerInfo.fromJson(jsonDecode(givenVanillaServerInfo));

      const expected = VanillaServerInfo(
        downloads: VanillaServerDownloadsInfo(
          server: VanillaServerDownloadsServerInfo(
            sha1: '2f31a8584ec1e70abd2d8b22d976feb52a6a3e31',
            size: 47275073,
            url:
                'https://piston-data.mojang.com/v1/objects/2f31a8584ec1e70abd2d8b22d976feb52a6a3e31/server.jar',
          ),
        ),
      );
      expect(result, expected);
    });
  });
}

const givenVanillaServerInfo = r'''
{
  "arguments": {
    "game": [
      "--username",
      "${auth_player_name}",
      "--version",
      "${version_name}",
      "--gameDir",
      "${game_directory}",
      "--assetsDir",
      "${assets_root}",
      "--assetIndex",
      "${assets_index_name}",
      "--uuid",
      "${auth_uuid}",
      "--accessToken",
      "${auth_access_token}",
      "--clientId",
      "${clientid}",
      "--xuid",
      "${auth_xuid}",
      "--userType",
      "${user_type}",
      "--versionType",
      "${version_type}",
      {
        "rules": [
          {
            "action": "allow",
            "features": {
              "is_demo_user": true
            }
          }
        ],
        "value": "--demo"
      },
      {
        "rules": [
          {
            "action": "allow",
            "features": {
              "has_custom_resolution": true
            }
          }
        ],
        "value": [
          "--width",
          "${resolution_width}",
          "--height",
          "${resolution_height}"
        ]
      }
    ],
    "jvm": [
      {
        "rules": [
          {
            "action": "allow",
            "os": {
              "name": "osx"
            }
          }
        ],
        "value": [
          "-XstartOnFirstThread"
        ]
      },
      {
        "rules": [
          {
            "action": "allow",
            "os": {
              "name": "windows"
            }
          }
        ],
        "value": "-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump"
      },
      {
        "rules": [
          {
            "action": "allow",
            "os": {
              "name": "windows",
              "version": "^10\\."
            }
          }
        ],
        "value": [
          "-Dos.name=Windows 10",
          "-Dos.version=10.0"
        ]
      },
      {
        "rules": [
          {
            "action": "allow",
            "os": {
              "arch": "x86"
            }
          }
        ],
        "value": "-Xss1M"
      },
      "-Djava.library.path=${natives_directory}",
      "-Dminecraft.launcher.brand=${launcher_name}",
      "-Dminecraft.launcher.version=${launcher_version}",
      "-cp",
      "${classpath}"
    ]
  },
  "assetIndex": {
    "id": "2",
    "sha1": "63b14365d7df8a206d2fae60e3400d84bab5a7a4",
    "size": 390746,
    "totalSize": 549080055,
    "url": "https://piston-meta.mojang.com/v1/packages/63b14365d7df8a206d2fae60e3400d84bab5a7a4/2.json"
  },
  "assets": "2",
  "complianceLevel": 1,
  "downloads": {
    "client": {
      "sha1": "2623aee01948e8ed29b3a52e5504c4d1fd63c7ae",
      "size": 23006318,
      "url": "https://piston-data.mojang.com/v1/objects/2623aee01948e8ed29b3a52e5504c4d1fd63c7ae/client.jar"
    },
    "client_mappings": {
      "sha1": "4ef420245e54a29c2bbd38caf3d8d66964610756",
      "size": 7660122,
      "url": "https://piston-data.mojang.com/v1/objects/4ef420245e54a29c2bbd38caf3d8d66964610756/client.txt"
    },
    "server": {
      "sha1": "2f31a8584ec1e70abd2d8b22d976feb52a6a3e31",
      "size": 47275073,
      "url": "https://piston-data.mojang.com/v1/objects/2f31a8584ec1e70abd2d8b22d976feb52a6a3e31/server.jar"
    },
    "server_mappings": {
      "sha1": "868745891d933db0ae97afd7046416a2af961e86",
      "size": 5914650,
      "url": "https://piston-data.mojang.com/v1/objects/868745891d933db0ae97afd7046416a2af961e86/server.txt"
    }
  },
  "id": "23w04a",
  "javaVersion": {
    "component": "java-runtime-gamma",
    "majorVersion": 17
  },
  "libraries": [
    {
      "downloads": {
        "artifact": {
          "path": "ca/weblite/java-objc-bridge/1.1/java-objc-bridge-1.1.jar",
          "sha1": "1227f9e0666314f9de41477e3ec277e542ed7f7b",
          "size": 1330045,
          "url": "https://libraries.minecraft.net/ca/weblite/java-objc-bridge/1.1/java-objc-bridge-1.1.jar"
        }
      },
      "name": "ca.weblite:java-objc-bridge:1.1",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/github/oshi/oshi-core/6.2.2/oshi-core-6.2.2.jar",
          "sha1": "54f5efc19bca95d709d9a37d19ffcbba3d21c1a6",
          "size": 947865,
          "url": "https://libraries.minecraft.net/com/github/oshi/oshi-core/6.2.2/oshi-core-6.2.2.jar"
        }
      },
      "name": "com.github.oshi:oshi-core:6.2.2"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/google/code/gson/gson/2.10/gson-2.10.jar",
          "sha1": "dd9b193aef96e973d5a11ab13cd17430c2e4306b",
          "size": 286235,
          "url": "https://libraries.minecraft.net/com/google/code/gson/gson/2.10/gson-2.10.jar"
        }
      },
      "name": "com.google.code.gson:gson:2.10"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar",
          "sha1": "1dcf1de382a0bf95a3d8b0849546c88bac1292c9",
          "size": 4617,
          "url": "https://libraries.minecraft.net/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar"
        }
      },
      "name": "com.google.guava:failureaccess:1.0.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/google/guava/guava/31.1-jre/guava-31.1-jre.jar",
          "sha1": "60458f877d055d0c9114d9e1a2efb737b4bc282c",
          "size": 2959479,
          "url": "https://libraries.minecraft.net/com/google/guava/guava/31.1-jre/guava-31.1-jre.jar"
        }
      },
      "name": "com.google.guava:guava:31.1-jre"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/ibm/icu/icu4j/71.1/icu4j-71.1.jar",
          "sha1": "9e7d3304c23f9ba5cb71915f7cce23231a57a445",
          "size": 13963762,
          "url": "https://libraries.minecraft.net/com/ibm/icu/icu4j/71.1/icu4j-71.1.jar"
        }
      },
      "name": "com.ibm.icu:icu4j:71.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/authlib/3.16.29/authlib-3.16.29.jar",
          "sha1": "efcca7a2fd33a399287834787f3a899086752b14",
          "size": 117060,
          "url": "https://libraries.minecraft.net/com/mojang/authlib/3.16.29/authlib-3.16.29.jar"
        }
      },
      "name": "com.mojang:authlib:3.16.29"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/blocklist/1.0.10/blocklist-1.0.10.jar",
          "sha1": "5c685c5ffa94c4cd39496c7184c1d122e515ecef",
          "size": 964,
          "url": "https://libraries.minecraft.net/com/mojang/blocklist/1.0.10/blocklist-1.0.10.jar"
        }
      },
      "name": "com.mojang:blocklist:1.0.10"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/brigadier/1.0.18/brigadier-1.0.18.jar",
          "sha1": "c1ef1234282716483c92183f49bef47b1a89bfa9",
          "size": 77116,
          "url": "https://libraries.minecraft.net/com/mojang/brigadier/1.0.18/brigadier-1.0.18.jar"
        }
      },
      "name": "com.mojang:brigadier:1.0.18"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/datafixerupper/5.0.28/datafixerupper-5.0.28.jar",
          "sha1": "e2157e236e529aff80a5fc3ccb506e56d46b130b",
          "size": 684966,
          "url": "https://libraries.minecraft.net/com/mojang/datafixerupper/5.0.28/datafixerupper-5.0.28.jar"
        }
      },
      "name": "com.mojang:datafixerupper:5.0.28"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/logging/1.1.1/logging-1.1.1.jar",
          "sha1": "832b8e6674a9b325a5175a3a6267dfaf34c85139",
          "size": 15343,
          "url": "https://libraries.minecraft.net/com/mojang/logging/1.1.1/logging-1.1.1.jar"
        }
      },
      "name": "com.mojang:logging:1.1.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/patchy/2.2.10/patchy-2.2.10.jar",
          "sha1": "da05971b07cbb379d002cf7eaec6a2048211fefc",
          "size": 4439,
          "url": "https://libraries.minecraft.net/com/mojang/patchy/2.2.10/patchy-2.2.10.jar"
        }
      },
      "name": "com.mojang:patchy:2.2.10"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/text2speech/1.13.9/text2speech-1.13.9.jar",
          "sha1": "5f4e3a6ef86cb021f7ca87ca192cddb50c26eb59",
          "size": 12123,
          "url": "https://libraries.minecraft.net/com/mojang/text2speech/1.13.9/text2speech-1.13.9.jar"
        }
      },
      "name": "com.mojang:text2speech:1.13.9"
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/text2speech/1.13.9/text2speech-1.13.9-natives-linux.jar",
          "sha1": "6c63ecb3b6408dcfdde6440c9ee62c060542af33",
          "size": 7833,
          "url": "https://libraries.minecraft.net/com/mojang/text2speech/1.13.9/text2speech-1.13.9-natives-linux.jar"
        }
      },
      "name": "com.mojang:text2speech:1.13.9:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "com/mojang/text2speech/1.13.9/text2speech-1.13.9-natives-windows.jar",
          "sha1": "7a90898b29e5c72f90ba6ebe86fa78a6afd7d3eb",
          "size": 81379,
          "url": "https://libraries.minecraft.net/com/mojang/text2speech/1.13.9/text2speech-1.13.9-natives-windows.jar"
        }
      },
      "name": "com.mojang:text2speech:1.13.9:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "commons-codec/commons-codec/1.15/commons-codec-1.15.jar",
          "sha1": "49d94806b6e3dc933dacbd8acb0fdbab8ebd1e5d",
          "size": 353793,
          "url": "https://libraries.minecraft.net/commons-codec/commons-codec/1.15/commons-codec-1.15.jar"
        }
      },
      "name": "commons-codec:commons-codec:1.15"
    },
    {
      "downloads": {
        "artifact": {
          "path": "commons-io/commons-io/2.11.0/commons-io-2.11.0.jar",
          "sha1": "a2503f302b11ebde7ebc3df41daebe0e4eea3689",
          "size": 327135,
          "url": "https://libraries.minecraft.net/commons-io/commons-io/2.11.0/commons-io-2.11.0.jar"
        }
      },
      "name": "commons-io:commons-io:2.11.0"
    },
    {
      "downloads": {
        "artifact": {
          "path": "commons-logging/commons-logging/1.2/commons-logging-1.2.jar",
          "sha1": "4bfc12adfe4842bf07b657f0369c4cb522955686",
          "size": 61829,
          "url": "https://libraries.minecraft.net/commons-logging/commons-logging/1.2/commons-logging-1.2.jar"
        }
      },
      "name": "commons-logging:commons-logging:1.2"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-buffer/4.1.82.Final/netty-buffer-4.1.82.Final.jar",
          "sha1": "a544270cf1ae8b8077082f5036436a9a9971ea71",
          "size": 304664,
          "url": "https://libraries.minecraft.net/io/netty/netty-buffer/4.1.82.Final/netty-buffer-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-buffer:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-codec/4.1.82.Final/netty-codec-4.1.82.Final.jar",
          "sha1": "b77200379acb345a9ffdece1c605e591ac3e4e0a",
          "size": 339155,
          "url": "https://libraries.minecraft.net/io/netty/netty-codec/4.1.82.Final/netty-codec-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-codec:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-common/4.1.82.Final/netty-common-4.1.82.Final.jar",
          "sha1": "022d148e85c3f5ebdacc0ce1f5aabb1d420f73f3",
          "size": 653880,
          "url": "https://libraries.minecraft.net/io/netty/netty-common/4.1.82.Final/netty-common-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-common:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-handler/4.1.82.Final/netty-handler-4.1.82.Final.jar",
          "sha1": "644041d1fa96a5d3130a29e8978630d716d76e38",
          "size": 538569,
          "url": "https://libraries.minecraft.net/io/netty/netty-handler/4.1.82.Final/netty-handler-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-handler:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-resolver/4.1.82.Final/netty-resolver-4.1.82.Final.jar",
          "sha1": "38f665ae8dcd29032eea31245ba7806bed2e0fa8",
          "size": 37776,
          "url": "https://libraries.minecraft.net/io/netty/netty-resolver/4.1.82.Final/netty-resolver-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-resolver:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-transport-classes-epoll/4.1.82.Final/netty-transport-classes-epoll-4.1.82.Final.jar",
          "sha1": "e7c7dd18deac93105797f30057c912651ea76521",
          "size": 142066,
          "url": "https://libraries.minecraft.net/io/netty/netty-transport-classes-epoll/4.1.82.Final/netty-transport-classes-epoll-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-transport-classes-epoll:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-transport-native-epoll/4.1.82.Final/netty-transport-native-epoll-4.1.82.Final-linux-aarch_64.jar",
          "sha1": "476409d6255001ca53a55f65b01c13822f8dc93a",
          "size": 39489,
          "url": "https://libraries.minecraft.net/io/netty/netty-transport-native-epoll/4.1.82.Final/netty-transport-native-epoll-4.1.82.Final-linux-aarch_64.jar"
        }
      },
      "name": "io.netty:netty-transport-native-epoll:4.1.82.Final:linux-aarch_64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-transport-native-epoll/4.1.82.Final/netty-transport-native-epoll-4.1.82.Final-linux-x86_64.jar",
          "sha1": "c7350a71920f3ae9142945e25fed4846cce53374",
          "size": 37922,
          "url": "https://libraries.minecraft.net/io/netty/netty-transport-native-epoll/4.1.82.Final/netty-transport-native-epoll-4.1.82.Final-linux-x86_64.jar"
        }
      },
      "name": "io.netty:netty-transport-native-epoll:4.1.82.Final:linux-x86_64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-transport-native-unix-common/4.1.82.Final/netty-transport-native-unix-common-4.1.82.Final.jar",
          "sha1": "3e895b35ca1b8a0eca56cacff4c2dde5d2c6abce",
          "size": 43684,
          "url": "https://libraries.minecraft.net/io/netty/netty-transport-native-unix-common/4.1.82.Final/netty-transport-native-unix-common-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-transport-native-unix-common:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "io/netty/netty-transport/4.1.82.Final/netty-transport-4.1.82.Final.jar",
          "sha1": "e431a218d91acb6476ccad5f5aafde50aa3945ca",
          "size": 485752,
          "url": "https://libraries.minecraft.net/io/netty/netty-transport/4.1.82.Final/netty-transport-4.1.82.Final.jar"
        }
      },
      "name": "io.netty:netty-transport:4.1.82.Final"
    },
    {
      "downloads": {
        "artifact": {
          "path": "it/unimi/dsi/fastutil/8.5.9/fastutil-8.5.9.jar",
          "sha1": "bb7ea75ecdb216654237830b3a96d87ad91f8cc5",
          "size": 23376043,
          "url": "https://libraries.minecraft.net/it/unimi/dsi/fastutil/8.5.9/fastutil-8.5.9.jar"
        }
      },
      "name": "it.unimi.dsi:fastutil:8.5.9"
    },
    {
      "downloads": {
        "artifact": {
          "path": "net/java/dev/jna/jna-platform/5.12.1/jna-platform-5.12.1.jar",
          "sha1": "097406a297c852f4a41e688a176ec675f72e8329",
          "size": 1356627,
          "url": "https://libraries.minecraft.net/net/java/dev/jna/jna-platform/5.12.1/jna-platform-5.12.1.jar"
        }
      },
      "name": "net.java.dev.jna:jna-platform:5.12.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "net/java/dev/jna/jna/5.12.1/jna-5.12.1.jar",
          "sha1": "b1e93a735caea94f503e95e6fe79bf9cdc1e985d",
          "size": 1866196,
          "url": "https://libraries.minecraft.net/net/java/dev/jna/jna/5.12.1/jna-5.12.1.jar"
        }
      },
      "name": "net.java.dev.jna:jna:5.12.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "net/sf/jopt-simple/jopt-simple/5.0.4/jopt-simple-5.0.4.jar",
          "sha1": "4fdac2fbe92dfad86aa6e9301736f6b4342a3f5c",
          "size": 78146,
          "url": "https://libraries.minecraft.net/net/sf/jopt-simple/jopt-simple/5.0.4/jopt-simple-5.0.4.jar"
        }
      },
      "name": "net.sf.jopt-simple:jopt-simple:5.0.4"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar",
          "sha1": "4ec95b60d4e86b5c95a0e919cb172a0af98011ef",
          "size": 1018316,
          "url": "https://libraries.minecraft.net/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar"
        }
      },
      "name": "org.apache.commons:commons-compress:1.21"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar",
          "sha1": "c6842c86792ff03b9f1d1fe2aab8dc23aa6c6f0e",
          "size": 587402,
          "url": "https://libraries.minecraft.net/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar"
        }
      },
      "name": "org.apache.commons:commons-lang3:3.12.0"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.jar",
          "sha1": "e5f6cae5ca7ecaac1ec2827a9e2d65ae2869cada",
          "size": 780321,
          "url": "https://libraries.minecraft.net/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.jar"
        }
      },
      "name": "org.apache.httpcomponents:httpclient:4.5.13"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/httpcomponents/httpcore/4.4.15/httpcore-4.4.15.jar",
          "sha1": "7f2e0c573eaa7a74bac2e89b359e1f73d92a0a1d",
          "size": 328324,
          "url": "https://libraries.minecraft.net/org/apache/httpcomponents/httpcore/4.4.15/httpcore-4.4.15.jar"
        }
      },
      "name": "org.apache.httpcomponents:httpcore:4.4.15"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/logging/log4j/log4j-api/2.19.0/log4j-api-2.19.0.jar",
          "sha1": "ea1b37f38c327596b216542bc636cfdc0b8036fa",
          "size": 317566,
          "url": "https://libraries.minecraft.net/org/apache/logging/log4j/log4j-api/2.19.0/log4j-api-2.19.0.jar"
        }
      },
      "name": "org.apache.logging.log4j:log4j-api:2.19.0"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/logging/log4j/log4j-core/2.19.0/log4j-core-2.19.0.jar",
          "sha1": "3b6eeb4de4c49c0fe38a4ee27188ff5fee44d0bb",
          "size": 1864386,
          "url": "https://libraries.minecraft.net/org/apache/logging/log4j/log4j-core/2.19.0/log4j-core-2.19.0.jar"
        }
      },
      "name": "org.apache.logging.log4j:log4j-core:2.19.0"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/apache/logging/log4j/log4j-slf4j2-impl/2.19.0/log4j-slf4j2-impl-2.19.0.jar",
          "sha1": "5c04bfdd63ce9dceb2e284b81e96b6a70010ee10",
          "size": 27721,
          "url": "https://libraries.minecraft.net/org/apache/logging/log4j/log4j-slf4j2-impl/2.19.0/log4j-slf4j2-impl-2.19.0.jar"
        }
      },
      "name": "org.apache.logging.log4j:log4j-slf4j2-impl:2.19.0"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/joml/joml/1.10.5/joml-1.10.5.jar",
          "sha1": "22566d58af70ad3d72308bab63b8339906deb649",
          "size": 712082,
          "url": "https://libraries.minecraft.net/org/joml/joml/1.10.5/joml-1.10.5.jar"
        }
      },
      "name": "org.joml:joml:1.10.5"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1.jar",
          "sha1": "cbac1b8d30cb4795149c1ef540f912671a8616d0",
          "size": 128801,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-glfw:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-linux.jar",
          "sha1": "81716978214ecbda15050ca394b06ef61501a49e",
          "size": 119817,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-glfw:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-macos.jar",
          "sha1": "9ec4ce1fc8c85fdef03ef4ff2aace6f5775fb280",
          "size": 131655,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-glfw:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-macos-arm64.jar",
          "sha1": "cac0d3f712a3da7641fa174735a5f315de7ffe0a",
          "size": 129077,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-glfw:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-windows.jar",
          "sha1": "ed892f945cf7e79c8756796f32d00fa4ceaf573b",
          "size": 145512,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-glfw:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-windows-x86.jar",
          "sha1": "b997e3391d6ce8f05487e7335d95c606043884a1",
          "size": 139251,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-glfw/3.3.1/lwjgl-glfw-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-glfw:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1.jar",
          "sha1": "a817bcf213db49f710603677457567c37d53e103",
          "size": 36601,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-jemalloc:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-linux.jar",
          "sha1": "33dbb017b6ed6b25f993ad9d56741a49e7937718",
          "size": 166524,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-jemalloc:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-macos.jar",
          "sha1": "56424dc8db3cfb8e7b594aa6d59a4f4387b7f544",
          "size": 117480,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-jemalloc:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-macos-arm64.jar",
          "sha1": "e577b87d8ad2ade361aaea2fcf226c660b15dee8",
          "size": 103475,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-jemalloc:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-windows.jar",
          "sha1": "948a89b76a16aa324b046ae9308891216ffce5f9",
          "size": 135585,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-jemalloc:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-windows-x86.jar",
          "sha1": "fb476c8ec110e1c137ad3ce8a7f7bfe6b11c6324",
          "size": 110405,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-jemalloc/3.3.1/lwjgl-jemalloc-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-jemalloc:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1.jar",
          "sha1": "2623a6b8ae1dfcd880738656a9f0243d2e6840bd",
          "size": 88237,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-openal:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-linux.jar",
          "sha1": "f906b6439f6daa66001182ea7727e3467a93681b",
          "size": 476825,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-openal:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-macos.jar",
          "sha1": "3a57b8911835fb58b5e558d0ca0d28157e263d45",
          "size": 397196,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-openal:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-macos-arm64.jar",
          "sha1": "23d55e7490b57495320f6c9e1936d78fd72c4ef8",
          "size": 346125,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-openal:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-windows.jar",
          "sha1": "30a474d0e57193d7bc128849a3ab66bc9316fdb1",
          "size": 576872,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-openal:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-windows-x86.jar",
          "sha1": "888349f7b1be6fbae58bf8edfb9ef12def04c4e3",
          "size": 520313,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-openal/3.3.1/lwjgl-openal-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-openal:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1.jar",
          "sha1": "831a5533a21a5f4f81bbc51bb13e9899319b5411",
          "size": 921563,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-opengl:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-linux.jar",
          "sha1": "ab9ab6fde3743e3550fa5d46d785ecb45b047d99",
          "size": 79125,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-opengl:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-macos.jar",
          "sha1": "a0d12697ea019a7362eff26475b0531340e876a6",
          "size": 40709,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-opengl:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-macos-arm64.jar",
          "sha1": "eafe34b871d966292e8db0f1f3d6b8b110d4e91d",
          "size": 41665,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-opengl:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-windows.jar",
          "sha1": "c1807e9bd571402787d7e37e3029776ae2513bb8",
          "size": 100205,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-opengl:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-windows-x86.jar",
          "sha1": "deef3eb9b178ff2ff3ce893cc72ae741c3a17974",
          "size": 87463,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-opengl/3.3.1/lwjgl-opengl-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-opengl:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1.jar",
          "sha1": "b119297cf8ed01f247abe8685857f8e7fcf5980f",
          "size": 112380,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-stb:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-linux.jar",
          "sha1": "3ee7aec8686e52867677110415566a5342a80230",
          "size": 227237,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-stb:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-macos.jar",
          "sha1": "def8879b8d38a47a4cc1d48b1f9a7b772e51258e",
          "size": 203582,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-stb:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-macos-arm64.jar",
          "sha1": "fcf073ed911752abdca5f0b00a53cfdf17ff8e8b",
          "size": 178408,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-stb:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-windows.jar",
          "sha1": "86315914ac119efdb02dc9e8e978ade84f1702af",
          "size": 256301,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-stb:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-windows-x86.jar",
          "sha1": "a8d41f419eecb430b7c91ea2ce2c5c451cae2091",
          "size": 225147,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-stb/3.3.1/lwjgl-stb-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-stb:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1.jar",
          "sha1": "0ff1914111ef2e3e0110ef2dabc8d8cdaad82347",
          "size": 6767,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-tinyfd:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-linux.jar",
          "sha1": "a35110b9471bea8cde826ab297550ee8c22f5035",
          "size": 45389,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-tinyfd:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-macos.jar",
          "sha1": "78641a0fa5e9afa714adfdd152c357930c97a1ce",
          "size": 44821,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-tinyfd:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-macos-arm64.jar",
          "sha1": "972ecc17bad3571e81162153077b4d47b7b9eaa9",
          "size": 41380,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-tinyfd:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-windows.jar",
          "sha1": "a5d830475ec0958d9fdba1559efa99aef211e6ff",
          "size": 127930,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-tinyfd:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-windows-x86.jar",
          "sha1": "842eedd876fae354abc308c98a263f6bbc9e8a4d",
          "size": 110042,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl-tinyfd/3.3.1/lwjgl-tinyfd-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl-tinyfd:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1.jar",
          "sha1": "ae58664f88e18a9bb2c77b063833ca7aaec484cb",
          "size": 724243,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1.jar"
        }
      },
      "name": "org.lwjgl:lwjgl:3.3.1"
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-linux.jar",
          "sha1": "1de885aba434f934201b99f2f1afb142036ac189",
          "size": 110704,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-linux.jar"
        }
      },
      "name": "org.lwjgl:lwjgl:3.3.1:natives-linux",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "linux"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-macos.jar",
          "sha1": "fc6bb723dec2cd031557dccb2a95f0ab80acb9db",
          "size": 55706,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-macos.jar"
        }
      },
      "name": "org.lwjgl:lwjgl:3.3.1:natives-macos",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-macos-arm64.jar",
          "sha1": "71d0d5e469c9c95351eb949064497e3391616ac9",
          "size": 42693,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-macos-arm64.jar"
        }
      },
      "name": "org.lwjgl:lwjgl:3.3.1:natives-macos-arm64",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "osx"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-windows.jar",
          "sha1": "0036c37f16ab611b3aa11f3bcf80b1d509b4ce6b",
          "size": 159361,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-windows.jar"
        }
      },
      "name": "org.lwjgl:lwjgl:3.3.1:natives-windows",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-windows-x86.jar",
          "sha1": "3b14f4beae9dd39791ec9e12190a9380cd8a3ce6",
          "size": 134695,
          "url": "https://libraries.minecraft.net/org/lwjgl/lwjgl/3.3.1/lwjgl-3.3.1-natives-windows-x86.jar"
        }
      },
      "name": "org.lwjgl:lwjgl:3.3.1:natives-windows-x86",
      "rules": [
        {
          "action": "allow",
          "os": {
            "name": "windows"
          }
        }
      ]
    },
    {
      "downloads": {
        "artifact": {
          "path": "org/slf4j/slf4j-api/2.0.1/slf4j-api-2.0.1.jar",
          "sha1": "f48d81adce2abf5ad3cfe463df517952749e03bc",
          "size": 61388,
          "url": "https://libraries.minecraft.net/org/slf4j/slf4j-api/2.0.1/slf4j-api-2.0.1.jar"
        }
      },
      "name": "org.slf4j:slf4j-api:2.0.1"
    }
  ],
  "logging": {
    "client": {
      "argument": "-Dlog4j.configurationFile=${path}",
      "file": {
        "id": "client-1.12.xml",
        "sha1": "bd65e7d2e3c237be76cfbef4c2405033d7f91521",
        "size": 888,
        "url": "https://launcher.mojang.com/v1/objects/bd65e7d2e3c237be76cfbef4c2405033d7f91521/client-1.12.xml"
      },
      "type": "log4j2-xml"
    }
  },
  "mainClass": "net.minecraft.client.main.Main",
  "minimumLauncherVersion": 21,
  "releaseTime": "2023-01-24T15:19:06+00:00",
  "time": "2023-01-24T15:19:06+00:00",
  "type": "snapshot"
}
''';
