import 'package:flutter/material.dart';

void main() {
  runApp(const SultanPharmacyApp());
}

class SultanPharmacyApp extends StatelessWidget {
  const SultanPharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sultan Pharmacy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          primary: const Color(0xFF00796B),
          secondary: const Color(0xFFFF6F00),
        ),
        useMaterial3: true,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  bool isAdmin = false;

  // দোকানের ডায়নামিক সেটিংস
  String adminPassword = "1234";
  String bkashNumber = "01700-000000 (Personal)";
  String nagadNumber = "01800-000000 (Personal)";
  String helplineNumber = "01700-000000";
  String whatsappNumber = "01700-000000";
  String noticeText = "সুলতান ফার্মেসিতে স্বাগতম! ঘরে বসেই বাকি পরিশোধ ও প্রেসক্রিপশন অর্ডার করতে পারবেন।";

  // বাকি খাতা ডাটাবেস
  List<Map<String, dynamic>> customers = [
    {
      "name": "আব্দুর রহিম",
      "phone": "01711111111",
      "due": 1250.0,
      "notes": ["১৫ অক্টোবর: প্রেসারের ওষুধ ১ পাতা - ৫০০ ৳", "১৮ অক্টোবর: নাপা এক্সট্রা ও গ্যাস্ট্রিক - ৭৫০ ৳"]
    },
    {
      "name": "মো: রফিকুল ইসলাম",
      "phone": "01822222222",
      "due": 840.0,
      "notes": ["১২ অক্টোবর: ইনসুলিন ও সুগারের ওষুধ - ৮৪০ ৳"]
    },
    {
      "name": "কামাল হোসেন",
      "phone": "01933333333",
      "due": 420.0,
      "notes": ["১০ অক্টোবর: কাশির সিরাপ ও অ্যান্টিবায়োটিক - ৪২০ ৳"]
    },
  ];

  // পেন্ডিং পেমেন্ট রিকোয়েস্ট
  List<Map<String, dynamic>> paymentRequests = [];

  // প্রেসক্রিপশন ও কাস্টমার অর্ডার
  List<Map<String, dynamic>> orderList = [];

  // ডেইলি সেলস ও প্রফিট
  double todaySale = 0.0;
  double profitMargin = 12.0;
  double monthlyTarget = 300000.0;
  double currentMonthAchieved = 145000.0;

  // DIMS স্টাইল বাংলাদেশ ওষুধ ডাটাবেস
  List<Map<String, String>> medicineDatabase = [
    // গ্যাস্ট্রিক ও এসিডিটি
    {"name": "Seclo 20mg", "generic": "Omeprazole", "company": "Square", "type": "Capsule", "cat": "Gastric"},
    {"name": "Sergel 20mg", "generic": "Esomeprazole", "company": "Healthcare", "type": "Capsule", "cat": "Gastric"},
    {"name": "Maxpro 20mg", "generic": "Esomeprazole", "company": "Renata", "type": "Capsule", "cat": "Gastric"},
    {"name": "Nexum 20mg", "generic": "Esomeprazole", "company": "Beximco", "type": "Tablet", "cat": "Gastric"},
    {"name": "Pantonix 20mg", "generic": "Pantoprazole", "company": "Incepta", "type": "Tablet", "cat": "Gastric"},
    {"name": "Finix 20mg", "generic": "Rabeprazole", "company": "Opsonin", "type": "Tablet", "cat": "Gastric"},
    {"name": "Entacyd Plus", "generic": "Magaldrate + Simethicone", "company": "Square", "type": "Syrup", "cat": "Gastric"},
    
    // জ্বর, সর্দি ও ব্যথা
    {"name": "Napa 500mg", "generic": "Paracetamol", "company": "Beximco", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Napa Extra", "generic": "Paracetamol + Caffeine", "company": "Beximco", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Ace 500mg", "generic": "Paracetamol", "company": "Square", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Ace Plus", "generic": "Paracetamol + Caffeine", "company": "Square", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Fast 500mg", "generic": "Paracetamol", "company": "Acme", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Renova 500mg", "generic": "Paracetamol", "company": "Opsonin", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Torax 10mg", "generic": "Ketorolac Tromethamine", "company": "Square", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Rolac 10mg", "generic": "Ketorolac Tromethamine", "company": "Renata", "type": "Tablet", "cat": "Fever & Pain"},
    {"name": "Flamyd 400mg", "generic": "Metronidazole", "company": "Sanofi", "type": "Tablet", "cat": "Fever & Pain"},

    // অ্যান্টিবায়োটিক
    {"name": "Azithrocin 500mg", "generic": "Azithromycin", "company": "Beximco", "type": "Tablet", "cat": "Antibiotic"},
    {"name": "Zimax 500mg", "generic": "Azithromycin", "company": "Square", "type": "Tablet", "cat": "Antibiotic"},
    {"name": "Tridosil 500mg", "generic": "Azithromycin", "company": "Incepta", "type": "Tablet", "cat": "Antibiotic"},
    {"name": "Cef-3 200mg", "generic": "Cefixime", "company": "Square", "type": "Capsule", "cat": "Antibiotic"},
    {"name": "Moxacil 500mg", "generic": "Amoxicillin", "company": "Square", "type": "Capsule", "cat": "Antibiotic"},
    {"name": "Furocef 500mg", "generic": "Cefuroxime Axetil", "company": "Incepta", "type": "Tablet", "cat": "Antibiotic"},
    {"name": "Kilbac 500mg", "generic": "Cefuroxime Axetil", "company": "Healthcare", "type": "Tablet", "cat": "Antibiotic"},
    {"name": "Ciprocin 500mg", "generic": "Ciprofloxacin", "company": "Square", "type": "Tablet", "cat": "Antibiotic"},

    // অ্যালার্জি ও কাশি
    {"name": "Alatrol 10mg", "generic": "Cetirizine HCl", "company": "Square", "type": "Tablet", "cat": "Allergy & Cough"},
    {"name": "Fexo 120mg", "generic": "Fexofenadine HCl", "company": "Square", "type": "Tablet", "cat": "Allergy & Cough"},
    {"name": "Fexo 180mg", "generic": "Fexofenadine HCl", "company": "Square", "type": "Tablet", "cat": "Allergy & Cough"},
    {"name": "Tofen 1mg", "generic": "Ketotifen", "company": "Beximco", "type": "Syrup", "cat": "Allergy & Cough"},
    {"name": "Monas 10mg", "generic": "Montelukast", "company": "Acme", "type": "Tablet", "cat": "Allergy & Cough"},
    {"name": "Montene 10mg", "generic": "Montelukast", "company": "Square", "type": "Tablet", "cat": "Allergy & Cough"},
    {"name": "Adrylex", "generic": "Levocetirizine", "company": "Square", "type": "Tablet", "cat": "Allergy & Cough"},
    {"name": "Tusca", "generic": "Dextromethorphan + Guaiphenesin", "company": "Square", "type": "Syrup", "cat": "Allergy & Cough"},

    // ডায়াবেটিস ও প্রেশার
    {"name": "Compath 5/500", "generic": "Metformin + Linagliptin", "company": "Square", "type": "Tablet", "cat": "Diabetes & Pressure"},
    {"name": "Metfo 500mg", "generic": "Metformin HCl", "company": "Beximco", "type": "Tablet", "cat": "Diabetes & Pressure"},
    {"name": "Bizoran 5/20", "generic": "Amlodipine + Olmesartan", "company": "Square", "type": "Tablet", "cat": "Diabetes & Pressure"},
    {"name": "Camlosart 5/20", "generic": "Amlodipine + Olmesartan", "company": "Beximco", "type": "Tablet", "cat": "Diabetes & Pressure"},
    {"name": "Angilock 50mg", "generic": "Losartan Potassium", "company": "Square", "type": "Tablet", "cat": "Diabetes & Pressure"},
    {"name": "Osartil 50mg", "generic": "Losartan Potassium", "company": "Incepta", "type": "Tablet", "cat": "Diabetes & Pressure"},

    // ভিটামিন
    {"name": "Ceevit 250mg", "generic": "Vitamin C", "company": "Square", "type": "Chewable", "cat": "Vitamins"},
    {"name": "Bicozin", "generic": "Vitamin B Complex + Zinc", "company": "Square", "type": "Syrup", "cat": "Vitamins"},
    {"name": "Aristovit B", "generic": "Vitamin B Complex", "company": "Aristopharma", "type": "Tablet", "cat": "Vitamins"},
    {"name": "Coralcal-D", "generic": "Calcium Carbonate + Vit D3", "company": "Square", "type": "Tablet", "cat": "Vitamins"},
    {"name": "Calbo-D", "generic": "Calcium + Vitamin D3", "company": "Square", "type": "Tablet", "cat": "Vitamins"},
    {"name": "D-Rise 20000 IU", "generic": "Cholecalciferol", "company": "Square", "type": "Capsule", "cat": "Vitamins"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("সুলতান ফার্মেসি", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white)),
            Text("ডিজিটাল খাতা ও দোকান ম্যানেজমেন্ট", style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF00796B),
        actions: [
          IconButton(
            tooltip: "যোগাযোগ",
            icon: const Icon(Icons.support_agent, color: Colors.white),
            onPressed: () => _showContactDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (val) {
              if (val == 'admin') _showAdminAuthDialog();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'admin', child: Text(isAdmin ? "লগআউট (কাস্টমার মোড)" : "অ্যাডমিন লগইন")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.amber.shade100,
            child: Row(
              children: [
                const Icon(Icons.campaign, color: Colors.deepOrange, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    noticeText,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _getSelectedPage()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'বাকি খাতা'),
          const NavigationDestination(icon: Icon(Icons.medication), label: 'ওষুধ তালিকা'),
          const NavigationDestination(icon: Icon(Icons.receipt_long), label: 'প্রেসক্রিপশন'),
          if (isAdmin) const NavigationDestination(icon: Icon(Icons.analytics), label: 'সেলস ও লাভ'),
          if (isAdmin) const NavigationDestination(icon: Icon(Icons.settings), label: 'সেটিংস'),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (_currentIndex) {
      case 0: return _buildBakiScreen();
      case 1: return _buildMedicineDirectory();
      case 2: return _buildOrderScreen();
      case 3: return isAdmin ? _buildSalesTargetScreen() : _buildBakiScreen();
      case 4: return isAdmin ? _buildSettingsScreen() : _buildBakiScreen();
      default: return _buildBakiScreen();
    }
  }

  // ১. বাকি খাতা
  Widget _buildBakiScreen() {
    final searchPhoneController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          if (isAdmin) ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.person_add),
              label: const Text("+ নতুন কাস্টমার / বাকি যোগ করুন", style: TextStyle(fontSize: 16)),
              onPressed: () => _addNewDueDialog(),
            ),
            const SizedBox(height: 14),
          ],
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const Text("কাস্টমার বাকি অনুসন্ধান", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: searchPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "কাস্টমারের মোবাইল নম্বর লিখুন",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.search),
                    label: const Text("বাকি ও হিসাব দেখুন"),
                    onPressed: () {
                      final p = searchPhoneController.text.trim();
                      final cust = customers.firstWhere((c) => c['phone'] == p, orElse: () => {});
                      if (cust.isNotEmpty) {
                        _showCustomerDueDetails(cust);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("এই নম্বরে কোনো বকেয়া হিসাব পাওয়া যায়নি!")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payment, color: Colors.teal),
                      SizedBox(width: 8),
                      Text("বিকাশ ও নগদ নম্বর", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Divider(),
                  Text("• বিকাশ: $bkashNumber", style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text("• নগদ: $nagadNumber", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("সকল বকেয়া তালিকা", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text("মোট: ${customers.length} জন", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(c['name'][0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ),
                    title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("ফোন: ${c['phone']}\nনোট: ${(c['notes'] as List).isNotEmpty ? c['notes'].last : ''}"),
                    trailing: Text("৳ ${c['due'].toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () => _showCustomerDueDetails(c),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const Text("অনলাইন পেমেন্ট রিকোয়েস্ট", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            const SizedBox(height: 6),
            paymentRequests.isEmpty
                ? const Text("বর্তমানে কোনো পেন্ডিং রিকোয়েস্ট নেই।", style: TextStyle(color: Colors.grey))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentRequests.length,
                    itemBuilder: (context, index) {
                      final req = paymentRequests[index];
                      return Card(
                        color: Colors.amber.shade50,
                        child: ListTile(
                          title: Text("নম্বর: ${req['phone']} | ৳ ${req['amount']}"),
                          subtitle: Text("শেষ ৪ ডিজিট: ${req['last4']}"),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                String p = req['phone'];
                                double amt = req['amount'];
                                for (var c in customers) {
                                  if (c['phone'] == p) {
                                    c['due'] = (c['due'] - amt).clamp(0, double.infinity);
                                    c['notes'].add("অনলাইন পেমেন্ট অনুমোদিত: ৳ $amt (শেষ ৪: ${req['last4']})");
                                    break;
                                  }
                                }
                                paymentRequests.removeAt(index);
                              });
                            },
                            child: const Text("Approve"),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ],
      ),
    );
  }

  void _showCustomerDueDetails(Map<String, dynamic> cust) {
    final amountController = TextEditingController();
    final last4Controller = TextEditingController();
    final addDueAmountController = TextEditingController();
    final addDueNoteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(cust['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
            Text("৳ ${cust['due'].toStringAsFixed(0)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("মোবাইল: ${cust['phone']}"),
              const Divider(),
              const Text("নোট ও হিসাবের বিবরণ:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: 100,
                width: double.maxFinite,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: ListView.builder(
                  itemCount: (cust['notes'] as List).length,
                  itemBuilder: (context, i) => Text("• ${cust['notes'][i]}", style: const TextStyle(fontSize: 12)),
                ),
              ),
              const Divider(),
              if (isAdmin) ...[
                const Text("অ্যাডমিন অ্যাকশন:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                TextField(controller: addDueAmountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "টাকার পরিমাণ")),
                TextField(controller: addDueNoteController, decoration: const InputDecoration(labelText: "কী ওষুধ নিল? (নোট)")),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                        onPressed: () {
                          double addAmt = double.tryParse(addDueAmountController.text) ?? 0.0;
                          if (addAmt > 0) {
                            setState(() {
                              cust['due'] += addAmt;
                              cust['notes'].add("নতুন বাকি: ৳ $addAmt (${addDueNoteController.text})");
                            });
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text("+ বাকি যোগ"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                        onPressed: () {
                          double cashAmt = double.tryParse(addDueAmountController.text) ?? 0.0;
                          if (cashAmt > 0) {
                            setState(() {
                              cust['due'] = (cust['due'] - cashAmt).clamp(0, double.infinity);
                              cust['notes'].add("নগদ পরিশোধ: ৳ $cashAmt (${addDueNoteController.text})");
                            });
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text("ক্যাশ জমা"),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Text("বিকাশ বা নগদে পরিশোধের তথ্য:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "কত টাকা পাঠিয়েছেন?")),
                TextField(controller: last4Controller, keyboardType: TextInputType.number, maxLength: 4, decoration: const InputDecoration(labelText: "নম্বরের শেষ ৪ সংখ্যা")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () {
                    if (amountController.text.isNotEmpty && last4Controller.text.length == 4) {
                      setState(() {
                        paymentRequests.add({
                          "phone": cust['phone'],
                          "amount": double.tryParse(amountController.text) ?? 0.0,
                          "last4": last4Controller.text,
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("পেমেন্ট রিকোয়েস্ট পাঠানো হয়েছে!")));
                    }
                  },
                  child: const Text("পেমেন্ট রিকোয়েস্ট পাঠান"),
                ),
              ],
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বন্ধ করুন"))],
      ),
    );
  }

  void _addNewDueDialog() {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final amountC = TextEditingController();
    final noteC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("নতুন বাকি এন্ট্রি করুন", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameC, decoration: const InputDecoration(labelText: "কাস্টমারের নাম")),
              TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "মোবাইল নম্বর")),
              TextField(controller: amountC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "বাকি টাকার পরিমাণ (৳)")),
              TextField(controller: noteC, maxLines: 2, decoration: const InputDecoration(labelText: "ওষুধের বিবরণ / নোট")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
            onPressed: () {
              if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty && amountC.text.isNotEmpty) {
                setState(() {
                  customers.add({
                    "name": nameC.text,
                    "phone": phoneC.text,
                    "due": double.tryParse(amountC.text) ?? 0.0,
                    "notes": ["${DateTime.now().day}/${DateTime.now().month}: ${noteC.text} (৳ ${amountC.text})"],
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("সংরক্ষণ করুন"),
          ),
        ],
      ),
    );
  }

  // ২. ওষুধ তালিকা ও DIMS
  Widget _buildMedicineDirectory() {
    TextEditingController searchC = TextEditingController();
    List<Map<String, String>> filtered = List.from(medicineDatabase);

    return StatefulBuilder(
      builder: (context, setDirState) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              if (isAdmin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("মোট ওষুধ: ${medicineDatabase.length} টি", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("+ ওষুধ যুক্ত করুন"),
                      onPressed: () => _addNewMedicineDialog(setDirState),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              TextField(
                controller: searchC,
                decoration: InputDecoration(
                  hintText: "ওষুধের নাম বা জেনেরিক দিয়ে খুঁজুন...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (val) {
                  setDirState(() {
                    filtered = medicineDatabase.where((m) =>
                        m['name']!.toLowerCase().contains(val.toLowerCase()) ||
                        m['generic']!.toLowerCase().contains(val.toLowerCase()) ||
                        m['company']!.toLowerCase().contains(val.toLowerCase())).toList();
                  });
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.teal.shade50, child: const Icon(Icons.medication, color: Colors.teal)),
                        title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("জেনেরিক: ${item['generic']}\nকোম্পানি: ${item['company']}"),
                        trailing: Chip(label: Text(item['type']!), backgroundColor: Colors.teal.shade50),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addNewMedicineDialog(StateSetter setDirState) {
    final nameC = TextEditingController();
    final genericC = TextEditingController();
    final companyC = TextEditingController();
    final typeC = TextEditingController(text: "Tablet");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("নতুন ওষুধ যুক্ত করুন"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameC, decoration: const InputDecoration(labelText: "ওষুধের নাম (যেমন: Napa 500mg)")),
              TextField(controller: genericC, decoration: const InputDecoration(labelText: "জেনেরিক (যেমন: Paracetamol)")),
              TextField(controller: companyC, decoration: const InputDecoration(labelText: "কোম্পানি (যেমন: Square / Beximco)")),
              TextField(controller: typeC, decoration: const InputDecoration(labelText: "ধরন (Tablet / Capsule)")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (nameC.text.isNotEmpty && genericC.text.isNotEmpty) {
                setState(() {
                  medicineDatabase.insert(0, {
                    "name": nameC.text,
                    "generic": genericC.text,
                    "company": companyC.text.isEmpty ? "Local" : companyC.text,
                    "type": typeC.text,
                    "cat": "All",
                  });
                });
                setDirState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text("সংরক্ষণ করুন"),
          ),
        ],
      ),
    );
  }

  // ৩. প্রেসক্রিপশন স্ক্রিন
  Widget _buildOrderScreen() {
    final noteController = TextEditingController();
    final phoneController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const Text("প্রেসক্রিপশন আপলোড বা অর্ডার ফর্ম", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "মোবাইল নম্বর")),
                  TextField(controller: noteController, maxLines: 2, decoration: const InputDecoration(labelText: "ওষুধের নাম ও পরিমাণ")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                    onPressed: () {
                      if (phoneController.text.isNotEmpty) {
                        setState(() {
                          orderList.add({
                            "phone": phoneController.text,
                            "note": noteController.text,
                            "status": "Pending",
                          });
                        });
                        phoneController.clear();
                        noteController.clear();
                      }
                    },
                    child: const Text("অর্ডার কনফার্ম করুন"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text("অর্ডার তালিকা", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final ord = orderList[index];
              return Card(
                child: ListTile(
                  title: Text("ফোন: ${ord['phone']}"),
                  subtitle: Text("ওষুধ: ${ord['note']}"),
                  trailing: Chip(label: Text(ord['status']), backgroundColor: Colors.amber.shade100),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ৪. সেলস ও লাভ ট্র্যাকার
  Widget _buildSalesTargetScreen() {
    final saleC = TextEditingController();
    double netProfit = todaySale * (profitMargin / 100);
    double targetRemaining = (monthlyTarget - currentMonthAchieved).clamp(0, double.infinity);
    double progressPercent = (currentMonthAchieved / monthlyTarget).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView(
        children: [
          Card(
            color: Colors.teal.shade800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("আজকের সেলস ও লাভ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("মোট বিক্রি: ৳ ${todaySale.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white70)),
                  Text("লাভ ($profitMargin%): ৳ ${netProfit.toStringAsFixed(2)}", style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(controller: saleC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "আজকের মোট বিক্রি (৳)")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                    onPressed: () {
                      if (saleC.text.isNotEmpty) {
                        setState(() {
                          todaySale = double.tryParse(saleC.text) ?? 0.0;
                          currentMonthAchieved += todaySale;
                        });
                        saleC.clear();
                      }
                    },
                    child: const Text("বিক্রি সেভ করুন"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("মাসিক টার্গেট ট্র্যাকার", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: progressPercent, minHeight: 10),
                  const SizedBox(height: 6),
                  Text("টার্গেট: ৳ ${monthlyTarget.toStringAsFixed(0)} | অর্জিত: ৳ ${currentMonthAchieved.toStringAsFixed(0)}"),
                  Text("পিছিয়ে আছেন: ৳ ${targetRemaining.toStringAsFixed(0)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ৫. সেটিংস স্ক্রিন
  Widget _buildSettingsScreen() {
    final bkashC = TextEditingController(text: bkashNumber);
    final nagadC = TextEditingController(text: nagadNumber);
    final helplineC = TextEditingController(text: helplineNumber);
    final noticeC = TextEditingController(text: noticeText);
    final newPassC = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView(
        children: [
          const Text("দোকানের সেটিংস ও নম্বর পরিবর্তন", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TextField(controller: bkashC, decoration: const InputDecoration(labelText: "বিকাশ নম্বর")),
                  TextField(controller: nagadC, decoration: const InputDecoration(labelText: "নগদ নম্বর")),
                  TextField(controller: helplineC, decoration: const InputDecoration(labelText: "দোকানের ফোন / WhatsApp")),
                  TextField(controller: noticeC, decoration: const InputDecoration(labelText: "নোটিশ বোর্ডের লেখা")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                    onPressed: () {
                      setState(() {
                        bkashNumber = bkashC.text;
                        nagadNumber = nagadC.text;
                        helplineNumber = helplineC.text;
                        whatsappNumber = helplineC.text;
                        noticeText = noticeC.text;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("সেটিংস সংরক্ষিত হয়েছে!")));
                    },
                    child: const Text("সেটিংস সেভ করুন"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const Text("পাসওয়ার্ড পরিবর্তন", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: newPassC, obscureText: true, decoration: const InputDecoration(labelText: "নতুন পাসওয়ার্ড")),
                  ElevatedButton(
                    onPressed: () {
                      if (newPassC.text.isNotEmpty) {
                        setState(() => adminPassword = newPassC.text);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("পাসওয়ার্ড আপডেট হয়েছে!")));
                      }
                    },
                    child: const Text("পাসওয়ার্ড আপডেট"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdminAuthDialog() {
