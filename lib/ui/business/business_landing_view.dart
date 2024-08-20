import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_needer/ui/initial_view.dart';
import 'package:home_needer/widgets/go_to_home_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_needer/widgets/business_landing_container_view.dart';

class BusinessLandingView extends ConsumerStatefulWidget {
  BusinessLandingView({super.key});

  @override
  ConsumerState<BusinessLandingView> createState() =>
      _BusinessLandingViewState();
}

class _BusinessLandingViewState extends ConsumerState<BusinessLandingView> {
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 218, 148, 68),
      Color.fromARGB(255, 33, 170, 170)
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  void onNavigation(BuildContext context, String routerName) {
    Navigator.pushNamed(context, routerName);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userSession);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 93, 102),
        title: Text(
          'New Business',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.white70),
        ),
        centerTitle: true,
        actions: [GoToHomeView()],
        foregroundColor: Colors.amber,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 75, 93, 102),
              Color.fromARGB(255, 45, 57, 63),
              Color.fromARGB(255, 25, 32, 36)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select your business Type",
                  style: GoogleFonts.hind(
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = linearGradient),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GradientContainerView(
                  userId: user!.uid,
                  title: "House Essentials",
                  content:
                      "Register your business, like contractors, security systems, interior & exterior design, painting, cleaning etc.,.",
                  icon: const Icon(
                    Icons.house,
                    size: 34,
                    color: Color.fromARGB(255, 122, 72, 156),
                  ),
                  onNavigation: () {
                    onNavigation(context, 'createHouseEssentialView');
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GradientContainerView(
                  userId: user.uid,
                  title: "Events",
                  content:
                      "Register your business, like event management, photography, catering, etc.,.",
                  icon: const Icon(
                    Icons.event_seat_sharp,
                    size: 34,
                    color: Color.fromARGB(255, 122, 72, 156),
                  ),
                  onNavigation: () {
                    onNavigation(context, "createEventView");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GradientContainerView(
                  userId: user.uid,
                  title: "Travels",
                  content:
                      "Register your business, like travel agencies, hotels, cottages, resorts.",
                  icon: const Icon(
                    Icons.travel_explore,
                    size: 34,
                    color: Color.fromARGB(255, 122, 72, 156),
                  ),
                  onNavigation: () {
                    onNavigation(context, "createTravelsView");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GradientContainerView(
                  userId: user.uid,
                  title: "Financial Professionals",
                  content:
                      "Register your business, insurance, auditors, traders, banking.",
                  icon: const Icon(
                    Icons.attach_money,
                    size: 34,
                    color: Color.fromARGB(255, 122, 72, 156),
                  ),
                  onNavigation: () {
                    onNavigation(context, "createFinancialProfessionalView");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GradientContainerView(
                  userId: user.uid,
                  title: "Auto Mobiles",
                  content:
                      "Register your business, two wheeler, four wheeler, heavy vehicle services, towing services.",
                  icon: const Icon(
                    Icons.car_repair,
                    size: 34,
                    color: Color.fromARGB(255, 122, 72, 156),
                  ),
                  onNavigation: () {
                    onNavigation(context, "createAutoMobileView");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
