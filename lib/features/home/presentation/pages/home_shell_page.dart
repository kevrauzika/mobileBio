import 'package:flutter/material.dart';

import '../../../organisms/presentation/pages/events_page.dart';
import '../../../organisms/presentation/pages/feed_page.dart';
import '../../../organisms/presentation/pages/map_page.dart';
import '../../../organisms/presentation/pages/profile_page.dart';
import '../../../organisms/presentation/pages/registro_rapido_page.dart';

/// Navegação principal entre mapa, feed, registro, eventos e perfil.
class HomeShellPage extends StatefulWidget {
  /// Cria shell principal.
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _indice = 0;

  static const _telas = [
    MapPage(),
    FeedPage(),
    RegistroRapidoPage(),
    EventsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indice],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (index) => setState(() => _indice = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.rss_feed_outlined), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.add_a_photo_outlined), label: 'Registrar'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Eventos'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}
