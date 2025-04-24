import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'find_vets_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _addressController = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("YOUR_API_KEY_HERE");
    _addressController.addListener(_onAddressChanged);
  }

  void _onAddressChanged() async {
    if (_addressController.text.isNotEmpty) {
      var result = await googlePlace.autocomplete.get(_addressController.text);
      if (result != null && result.predictions != null) {
        setState(() => predictions = result.predictions!);
      }
    } else {
      setState(() => predictions = []);
    }
  }

  void _selectPrediction(AutocompletePrediction prediction) {
    _addressController.text = prediction.description!;
    setState(() => predictions = []);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FindVetsPage(address: prediction.description!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to MoonkyVet AI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your digital vet companion that helps you take better care of your furry friends — from health tracking to AI chat, vet finder and more!',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Find Vets Near You 🐶',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.65),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 42,
                        child: TextField(
                          controller: _addressController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Enter your address...',
                            hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                            filled: true,
                            fillColor: Colors.transparent,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 1,
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      if (predictions.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                border: const Border(
                                  top: BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                title: Text(
                                  predictions[index].description ?? '',
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                onTap: () => _selectPrediction(predictions[index]),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  'Who are you?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoleCard(
                      icon: Icons.pets,
                      label: 'Sign in as Pet Owner',
                      onTap: () => Navigator.pushNamed(context, '/login'),
                    ),
                    const SizedBox(width: 20),
                    _RoleCard(
                      icon: Icons.medical_services_outlined,
                      label: 'Sign in as Vet',
                      onTap: () => Navigator.pushNamed(context, '/register-vet'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}