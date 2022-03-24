import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:dio/dio.dart';
import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/app.dart';
import 'package:network_repository/network_repository.dart';
import 'package:path/path.dart' as p;
import 'package:process/process.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';
import 'package:server_management_repository/server_management_repository.dart';
import 'package:server_properties_repository/server_properties_repository.dart';
import 'package:server_repository/server_repository.dart';
import 'package:system_repository/system_repository.dart';
import 'package:url_launcher/url_launcher.dart';

void main(List<String> args) async {
  const isProduction = bool.fromEnvironment('dart.vm.product');
  const FileSystem fileSystem = LocalFileSystem();
  final Archiver archiver = Archiver(fileSystem: fileSystem);
  const PropertyManager propertyManager =
      PropertyManager(fileSystem: fileSystem);
  final Dio dio = Dio();
  const ProcessManager processManager = LocalProcessManager();
  const SystemRepository systemRepository =
      SystemRepository(processManager: processManager);
  const JavaInfoRepository javaInfoRepository = JavaInfoRepository(
    processManager: processManager,
    fileSystem: fileSystem,
  );
  final NetworkRepository networkRepository = NetworkRepository(
    processManager: processManager,
    dio: dio,
  );
  const LocaleRepository localeRepository = LocaleRepository(
    fileSystem: fileSystem,
    propertyManager: propertyManager,
  );
  const LauncherRepository launcherRepository =
      LauncherRepository(canLaunch, launch);

  final JarAnalyzerRepository jarAnalyzerRepository =
      JarAnalyzerRepository(fileSystem: fileSystem, archiver: archiver);
  final ServerManagementRepository serverManagementRepository =
      ServerManagementRepository(
    // jarAnalyzerRepository: jarAnalyzerRepository,
    fileSystem: fileSystem,
  );

  final InstallerRepository installerRepository =
      InstallerRepository(archiver: archiver, dio: dio, fileSystem: fileSystem);
  final ProcessCleanerRepository processCleanerRepository =
      ProcessCleanerRepository(processManager: processManager);
  final DuplicateCleanerRepository duplicateCleanerRepository =
      DuplicateCleanerRepository(fileSystem: fileSystem);
  final EulaStageRepository eulaStageRepository =
      EulaStageRepository(fileSystem: fileSystem);
  // final JarAnalyzerRepository jarAnalyzerRepository
  final CubePropertiesRepository cubePropertiesRepository =
      CubePropertiesRepository(
          // ignore: invalid_use_of_visible_for_testing_member
          // cubeProperties: const CubeProperties(propertyManager: propertyManager),
          );
  const JavaPrinterRepository javaPrinterRepository =
      JavaPrinterRepository(processManager: processManager);
  final JavaDuplicatorRepository javaDuplicatorRepository =
      JavaDuplicatorRepository(fileSystem: fileSystem);
  final ForgeInstallerRepository forgeInstallerRepository =
      ForgeInstallerRepository(processManager: processManager);
  final ServerRepository serverRepository =
      ServerRepository(processManager: processManager);
  final ConsoleRepository consoleRepository = ConsoleRepository();

  final ServerPropertiesRepository serverPropertiesRepository =
      ServerPropertiesRepository(
    fileSystem: fileSystem,
    propertyManager: propertyManager,
  );

  const InstallerCreatorRepository installerCreatorRepository =
      InstallerCreatorRepository(
    fileSystem: fileSystem,
  );

  if (!isProduction || args.contains('-dev')) {
    final absoluteProjectDir = fileSystem.currentDirectory.absolute;
    // Prevent Hot Restart from bug
    if (!absoluteProjectDir.path.contains('DEV_PROJECT')) {
      final targetDir = p.join(absoluteProjectDir.path, 'DEV_PROJECT');
      await fileSystem.directory(targetDir).create();
      fileSystem.currentDirectory = targetDir;
    }
  }

  runApp(
    CubeApp(
      localeRepository: localeRepository,
      networkRepository: networkRepository,
      javaInfoRepository: javaInfoRepository,
      systemRepository: systemRepository,
      launcherRepository: launcherRepository,
      serverManagementRepository: serverManagementRepository,
      installerRepository: installerRepository,
      processCleanerRepository: processCleanerRepository,
      duplicateCleanerRepository: duplicateCleanerRepository,
      eulaStageRepository: eulaStageRepository,
      jarAnalyzerRepository: jarAnalyzerRepository,
      cubePropertiesRepository: cubePropertiesRepository,
      javaPrinterRepository: javaPrinterRepository,
      javaDuplicatorRepository: javaDuplicatorRepository,
      forgeInstallerRepository: forgeInstallerRepository,
      serverRepository: serverRepository,
      consoleRepository: consoleRepository,
      serverPropertiesRepository: serverPropertiesRepository,
      installerCreatorRepository: installerCreatorRepository,
    ),
  );
  await DesktopWindow.setWindowSize(const Size(1400, 900));
  await DesktopWindow.setMinWindowSize(const Size(1280, 720));
  await DesktopWindow.setMaxWindowSize(const Size(1920, 1080));
}
