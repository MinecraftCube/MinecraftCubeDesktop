import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/_gen/assets.gen.dart';
import 'package:minecraft_cube_desktop/_gen/version.gen.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/about_page/about_page.i18n.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: ListView(
        primary: false,
        children: const [
          AboutBanner(),
          SizedBox(
            height: 12,
          ),
          IntroSection(),
        ],
      ),
    );
  }
}

class AboutBanner extends StatelessWidget {
  const AboutBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: Assets.resources.about,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white38,
                width: 2,
              ),
              gradient: const RadialGradient(
                colors: <Color>[
                  Color(0x00000000),
                  Color(0xdd000000),
                ],
                focalRadius: 16,
                radius: 1.5,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              color: Colors.black26,
              child: Text(
                aboutPageTitle.i18n,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  shadows: <Shadow>[
                    const Shadow(
                      offset: Offset(10.0, 10.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    const Shadow(
                      offset: Offset(10.0, 10.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(125, 0, 0, 255),
                    ),
                  ],
                  color: Colors.white60,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(8),
            child: const Text(
              packageVersion,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class IntroSection extends StatelessWidget {
  const IntroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          AuthorCard(),
          SizedBox(
            height: 12,
          ),
          AppCard(),
          SizedBox(
            height: 1024,
          ),
          SecretCard(),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class IntroAvatar extends StatelessWidget {
  const IntroAvatar({Key? key, required this.image}) : super(key: key);
  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(128),
        ),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.yellow],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Colors.white,
        backgroundImage: image,
      ),
    );
  }
}

class AuthorCard extends StatelessWidget {
  const AuthorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return IntroCard(
      bgColor: Colors.blue.shade100,
      child: Row(
        children: [
          IntroAvatar(
            image: Assets.resources.aboutMe,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.bodyLarge?.copyWith(height: 1.5),
                children: getAuthorTextSpan(
                  () => context.read<LauncherRepository>().launch(
                        path:
                            'https://www.youtube.com/channel/UCWx2R78GhmltZudJHLEnd5w?sub_comfirmation=1',
                      ),
                  textTheme,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroCard(
      bgColor: Colors.red.shade100,
      child: Row(
        children: [
          IntroAvatar(
            image: Assets.resources.logo,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.5),
                children: getAppTextSpan(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SecretCard extends StatelessWidget {
  const SecretCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroCard(
      bgColor: Colors.grey.shade300,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          children: getSecretTextSpan(),
        ),
      ),
    );
  }
}

class IntroCard extends StatelessWidget {
  const IntroCard({
    Key? key,
    required this.bgColor,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              1.0, // vertical, move down 10
            ),
          )
        ],
        border: Border.all(
          color: Colors.black87,
          width: 1,
        ),
        gradient: LinearGradient(
          colors: [Colors.white, bgColor],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
