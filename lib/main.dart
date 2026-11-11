import 'package:flutter/material.dart';

void main() {
  runApp(const SouzasBarApp());
}

class SouzasBarApp extends StatelessWidget {
  const SouzasBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFFB7F36B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Souza's Bar",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101211),
        colorScheme: const ColorScheme.dark(
          primary: green,
          surface: Color(0xFF1B201D),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const green = Color(0xFFB7F36B);
  static const muted = Color(0xFF929A94);
  static const panel = Color(0xFF1B201D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.sports_bar, color: green, size: 26),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SOUZA'S BAR",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          )),
                      SizedBox(height: 3),
                      Text("PAINEL DE COMANDAS",
                          style: TextStyle(
                            color: muted,
                            fontSize: 10,
                            letterSpacing: 1.5,
                          )),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                  color: muted,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("QUARTA-FEIRA, 11 DE NOVEMBRO",
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 7),
            const Text("Movimento de hoje",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("TOTAL EM VENDAS",
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                        letterSpacing: 1.3,
                      )),
                  const SizedBox(height: 8),
                  const Text("R\$ 0,00",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      _metric("CLIENTES", "0"),
                      const SizedBox(width: 28),
                      _metric("COMANDAS ABERTAS", "0"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text("NOVA COMANDA",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    )),
                style: FilledButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: const Color(0xFF17200F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 29),
            Row(
              children: [
                const Expanded(
                  child: Text("Comandas do dia",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      )),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text("Buscar"),
                  style: TextButton.styleFrom(foregroundColor: green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  Icon(Icons.receipt_long_rounded,
                      color: Color(0xFF68736B), size: 38),
                  SizedBox(height: 12),
                  Text("Nenhuma comanda por enquanto",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 6),
                  Text("As comandas abertas aparecerão aqui.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.receipt_long, label: "Comandas", active: true),
                _NavItem(icon: Icons.calendar_month, label: "Histórico"),
                _NavItem(icon: Icons.bar_chart_rounded, label: "Relatórios"),
                _NavItem(icon: Icons.settings_outlined, label: "Ajustes"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(
              color: muted,
              fontSize: 9,
              letterSpacing: 1,
            )),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFB7F36B) : const Color(0xFF929A94);
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}
