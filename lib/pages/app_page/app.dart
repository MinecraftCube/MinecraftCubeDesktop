import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:console_repository/console_repository.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';
import 'package:minecraft_cube_desktop/_theme/color_palette.dart';
import 'package:minecraft_cube_desktop/pages/app_page/app_selector_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/bloc/locale_bloc.dart';
import 'package:network_repository/network_repository.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';
import 'package:server_configuration_repository/server_configuration_repository.dart';
import 'package:server_management_repository/server_management_repository.dart';
import 'package:server_properties_repository/server_properties_repository.dart';
import 'package:server_repository/server_repository.dart';
import 'package:system_repository/system_repository.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

class CubeApp extends StatelessWidget {
  const CubeApp({
    required this.localeRepository,
    required this.networkRepository,
    required this.systemRepository,
    required this.javaInfoRepository,
    required this.launcherRepository,
    required this.serverManagementRepository,
    required this.installerRepository,
    required this.processCleanerRepository,
    required this.duplicateCleanerRepository,
    required this.eulaStageRepository,
    required this.jarAnalyzerRepository,
    required this.cubePropertiesRepository,
    required this.javaPrinterRepository,
    required this.javaDuplicatorRepository,
    required this.forgeInstallerRepository,
    required this.serverRepository,
    required this.consoleRepository,
    required this.serverPropertiesRepository,
    required this.installerCreatorRepository,
    required this.appUpdaterRepository,
    required this.serverConfigurationRepository,
    required this.vanillaServerRepository,
    Key? key,
  }) : super(key: key);
  final LocaleRepository localeRepository;
  final NetworkRepository networkRepository;
  final SystemRepository systemRepository;
  final JavaInfoRepository javaInfoRepository;
  final LauncherRepository launcherRepository;
  final ServerManagementRepository serverManagementRepository;
  final InstallerRepository installerRepository;
  final ProcessCleanerRepository processCleanerRepository;
  final DuplicateCleanerRepository duplicateCleanerRepository;
  final EulaStageRepository eulaStageRepository;
  final JarAnalyzerRepository jarAnalyzerRepository;
  final CubePropertiesRepository cubePropertiesRepository;
  final JavaPrinterRepository javaPrinterRepository;
  final JavaDuplicatorRepository javaDuplicatorRepository;
  final ForgeInstallerRepository forgeInstallerRepository;
  final ServerRepository serverRepository;
  final ConsoleRepository consoleRepository;
  final ServerPropertiesRepository serverPropertiesRepository;
  final InstallerCreatorRepository installerCreatorRepository;
  final AppUpdaterRepository appUpdaterRepository;
  final ServerConfigurationRepository serverConfigurationRepository;
  final VanillaServerRepository vanillaServerRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: networkRepository),
        RepositoryProvider.value(
          value: systemRepository,
        ),
        RepositoryProvider.value(
          value: javaInfoRepository,
        ),
        RepositoryProvider.value(
          value: launcherRepository,
        ),
        RepositoryProvider.value(
          value: serverManagementRepository,
        ),
        RepositoryProvider.value(
          value: installerRepository,
        ),
        RepositoryProvider.value(
          value: processCleanerRepository,
        ),
        RepositoryProvider.value(
          value: duplicateCleanerRepository,
        ),
        RepositoryProvider.value(
          value: eulaStageRepository,
        ),
        RepositoryProvider.value(
          value: jarAnalyzerRepository,
        ),
        RepositoryProvider.value(
          value: cubePropertiesRepository,
        ),
        RepositoryProvider.value(
          value: javaPrinterRepository,
        ),
        RepositoryProvider.value(
          value: javaDuplicatorRepository,
        ),
        RepositoryProvider.value(
          value: forgeInstallerRepository,
        ),
        RepositoryProvider.value(
          value: serverRepository,
        ),
        RepositoryProvider.value(
          value: serverConfigurationRepository,
        ),
        RepositoryProvider.value(value: consoleRepository),
        RepositoryProvider.value(value: serverPropertiesRepository),
        RepositoryProvider.value(value: installerCreatorRepository),
        RepositoryProvider.value(value: appUpdaterRepository),
        RepositoryProvider.value(value: vanillaServerRepository),
      ],
      child: BlocProvider<LocaleBloc>(
        create: (_) => LocaleBloc(localeRepository),
        child: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            return const CubeAppView();
          },
        ),
      ),
    );
  }
}

class CubeAppView extends StatefulWidget {
  const CubeAppView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CubeAppViewState();
}

class _CubeAppViewState extends State<CubeAppView> {
  @override
  void initState() {
    context.read<LocaleBloc>().add(LanguageInited());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return MaterialApp(
          locale: state.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            AppLocalization.enUS,
            AppLocalization.zhTW,
          ],
          title: 'Minecraft Cube',
          theme: ThemeData(
            primarySwatch:
                MaterialColor(ColorPalette.primarySwatch.value, const {
              50: Color(0xfff7eeed),
              100: Color(0xfff0dedb),
              200: Color(0xffe1bdb7),
              300: Color(0xffd19c94),
              400: Color(0xffc27b70),
              500: Color(0xffb35a4c),
              600: Color(0xff8f483d),
              700: Color(0xff6b362e),
              800: Color(0xff48241e),
              900: Color(0xff24120f)
            }),
            fontFamily: 'NotoSansTC',
          ),
          home: I18n(
            child: const AppSelectorPage(),
          ),
        );
      },
    );
  }
}
