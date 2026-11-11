import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const green = Color(0xFFB7F36B);
const muted = Color(0xFF929A94);
const panel = Color(0xFF1B201D);

void main() => runApp(const SouzasBarApp());

String money(double value) => 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

double number(String value) =>
    double.tryParse(value.trim().replaceAll(',', '.')) ?? 0;

class OrderItem {
  String name;
  double quantity;
  double price;

  OrderItem(this.name, this.quantity, this.price);

  double get total => quantity * price;
}

class BarOrder {
  final String customer;
  final List<OrderItem> items;
  final DateTime createdAt;

  BarOrder(this.customer, this.items, {DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  double get total => items.fold(0, (sum, item) => sum + item.total);
}

class SouzasBarApp extends StatelessWidget {
  const SouzasBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Souza's Bar",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101211),
        colorScheme: const ColorScheme.dark(
          primary: green,
          surface: panel,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<BarOrder> orders = [];

  double get total => orders.fold(0, (sum, order) => sum + order.total);

  Future<void> newOrder() async {
    final result = await Navigator.push<BarOrder>(
      context,
      MaterialPageRoute(builder: (_) => const NewOrderScreen()),
    );

    if (result != null) {
      setState(() => orders.insert(0, result));
    }
  }

  Future<void> editOrder(int index) async {
    final result = await Navigator.push<BarOrder>(context,
      MaterialPageRoute(builder: (_) => NewOrderScreen(order: orders[index])));
    if (result != null) setState(() => orders[index] = result);
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    const weekdays = [
      'SEGUNDA-FEIRA', 'TERÇA-FEIRA', 'QUARTA-FEIRA',
      'QUINTA-FEIRA', 'SEXTA-FEIRA', 'SÁBADO', 'DOMINGO'
    ];
    const months = [
      'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO',
      'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'
    ];

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
                    color: green.withValues(alpha: .13),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                      SizedBox(height: 3),
                      Text("PAINEL DE COMANDAS",
                          style: TextStyle(color: muted, fontSize: 10, letterSpacing: 1.5)),
                    ],
                  ),
                ),
                const Icon(Icons.notifications_none_rounded, color: muted),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              '${weekdays[date.weekday - 1]}, ${date.day} DE ${months[date.month - 1]}',
              style: const TextStyle(color: muted, fontSize: 11, letterSpacing: 1.2),
            ),
            const SizedBox(height: 7),
            const Text('Movimento de hoje',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: .05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL EM VENDAS',
                      style: TextStyle(color: muted, fontSize: 11, letterSpacing: 1.3)),
                  const SizedBox(height: 8),
                  Text(money(total),
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      _metric('CLIENTES', '${orders.length}'),
                      const SizedBox(width: 28),
                      _metric('COMANDAS ABERTAS', '${orders.length}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: newOrder,
                icon: const Icon(Icons.add_rounded),
                label: const Text('NOVA COMANDA',
                    style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .8)),
                style: FilledButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: const Color(0xFF17200F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                ),
              ),
            ),
            const SizedBox(height: 29),
            Row(
              children: [
                const Expanded(
                  child: Text('Comandas do dia',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Buscar'),
                  style: TextButton.styleFrom(foregroundColor: green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (orders.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22)),
                child: const Column(
                  children: [
                    Icon(Icons.receipt_long_rounded, color: Color(0xFF68736B), size: 38),
                    SizedBox(height: 12),
                    Text('Nenhuma comanda por enquanto',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 6),
                    Text('As comandas abertas aparecerão aqui.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFFFD45A), fontSize: 12)),
                  ],
                ),
              )
            else
              ...List.generate(orders.length, (i) => _orderCard(orders[i], i)),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.receipt_long, label: 'Comandas', active: true),
                _NavItem(icon: Icons.calendar_month, label: 'Histórico'),
                _NavItem(icon: Icons.bar_chart_rounded, label: 'Relatórios'),
                _NavItem(icon: Icons.settings_outlined, label: 'Ajustes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(color: muted, fontSize: 9, letterSpacing: 1)),
    ],
  );

  Widget _orderCard(BarOrder order, int index) => InkWell(
    onTap: () => editOrder(index),
    borderRadius: BorderRadius.circular(20),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: green, size: 27),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.customer, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                Text('${order.items.length} itens • Em andamento',
                    style: const TextStyle(color: Color(0xFFFFD45A), fontSize: 12)),
              ],
            ),
          ),
          Text(money(order.total),
              style: const TextStyle(color: green, fontWeight: FontWeight.w800)),
        ],
      ),
    ),
  );
}

class NewOrderScreen extends StatefulWidget {
  final BarOrder? order;
  const NewOrderScreen({super.key, this.order});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final customerController = TextEditingController();
  late final List<_ItemFields> items;

  @override
  void initState() {
    super.initState();
    if (widget.order == null) {
      items = [_ItemFields()];
    } else {
      customerController.text = widget.order!.customer;
      items = widget.order!.items.map((item) => _ItemFields.fromItem(item)).toList();
    }
  }

  double get total => items.fold(0, (sum, item) => sum + item.total);

  @override
  void dispose() {
    customerController.dispose();
    for (final item in items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> addItem() async {
    setState(() => items.add(_ItemFields()));
    await _editItem(items.length - 1, isNew: true);
  }

  void removeItem(int index) {
    if (items.length == 1) {
      items[index].clear();
      setState(() {});
      return;
    }
    setState(() {
      items[index].dispose();
      items.removeAt(index);
    });
  }

  void save() {
    final customer = customerController.text.trim();
    final validItems = items
        .where((item) => item.name.text.trim().isNotEmpty && item.quantity > 0 && item.price > 0)
        .map((item) => OrderItem(item.name.text.trim(), item.quantity, item.price))
        .toList();

    if (customer.isEmpty) {
      _message('Informe o nome do cliente.');
      return;
    }
    if (validItems.isEmpty) {
      _message('Adicione pelo menos um produto com quantidade e preço.');
      return;
    }

    Navigator.pop(context, BarOrder(customer, validItems, createdAt: widget.order?.createdAt));
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration decoration(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFF202622),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: green),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Nova comanda' : 'Editar comanda', style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: const Color(0xFF101211),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('DADOS DO CLIENTE',
              style: TextStyle(color: muted, fontSize: 11, letterSpacing: 1.3)),
          const SizedBox(height: 12),
          TextField(
            controller: customerController,
            textCapitalization: TextCapitalization.words,
            decoration: decoration('Nome do cliente', hint: 'Ex.: João'),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const Expanded(
                child: Text('Produtos da comanda',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              ),
              TextButton.icon(
                onPressed: addItem,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Adicionar'),
                style: TextButton.styleFrom(foregroundColor: green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _productTable(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('TOTAL DA COMANDA',
                    style: TextStyle(color: muted, fontSize: 16, fontWeight: FontWeight.w800)),
                ),
                Text(money(total),
                  style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: green)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.check_rounded),
              label: const Text('SALVAR COMANDA',
                  style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .7)),
              style: FilledButton.styleFrom(
                backgroundColor: green,
                foregroundColor: const Color(0xFF17200F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: muted)),
          ),
        ],
      ),
    );
  }


  Widget _productTable() {
    return Container(
      decoration: BoxDecoration(
        color: panel,
        border: Border.all(color: muted.withOpacity(.35)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            decoration: const BoxDecoration(
              color: Color(0xFF252820),
              borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 5, child: Text('Produto', style: TextStyle(fontWeight: FontWeight.w800))),
                Expanded(flex: 1, child: Text('Qtd.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800))),
                Expanded(flex: 2, child: Text('Valor', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w800))),
              ],
            ),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return InkWell(
              onTap: () => _editItem(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 19),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        item.name.text.isEmpty ? 'Novo produto' : item.name.text,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        item.quantityController.text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        money(item.total),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _editItem(int index, {bool isNew = false}) async {
    final item = items[index];
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          backgroundColor: panel,
          title: Text(isNew ? 'Adicionar produto' : 'Editar produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: item.name,
                textCapitalization: TextCapitalization.sentences,
                decoration: decoration('Produto', hint: 'Nome do produto'),
                onChanged: (_) => refresh(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: item.quantityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
                decoration: decoration('Quantidade', hint: '1'),
                onChanged: (_) => refresh(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: item.priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
                decoration: decoration('Preço unitário', hint: '0,00'),
                onChanged: (_) => refresh(() {}),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Subtotal: ${money(item.total)}',
                  style: const TextStyle(color: green, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Remover', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (result != true) {
      if (result == false || isNew) {
        removeItem(index);
      }
      return;
    }
    setState(() {});
  }

}

class _ItemFields {
  _ItemFields();
  _ItemFields.fromItem(OrderItem item) {
    name.text = item.name;
    quantityController.text = item.quantity.toString();
    priceController.text = item.price.toString();
  }
  final name = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final priceController = TextEditingController();

  double get quantity => number(quantityController.text);
  double get price => number(priceController.text);
  double get total => quantity * price;

  void clear() {
    name.clear();
    quantityController.text = '1';
    priceController.clear();
  }

  void dispose() {
    name.dispose();
    quantityController.dispose();
    priceController.dispose();
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? green : muted;
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}
