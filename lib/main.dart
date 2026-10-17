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

  // দোকানের সেটিংস
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
      "notes": <String>["১৫ অক্টোবর: প্রেসারের ওষুধ ১ পাতা - ৫০০ ৳", "১৮ অক্টোবর: নাপা এক্সট্রা ও গ্যাস্ট্রিক - ৭৫০ ৳"]
    },
    {
      "name": "মো: রফিকুল ইসলাম",
      "phone": "01822222222",
      "due": 840.0,
      "notes": <String>["১২ অক্টোবর: ইনসুলিন ও সুগারের ওষুধ - ৮৪০ ৳"]
    },
    {
      "name": "কামাল হোসেন",
      "phone": "01933333333",
      "due": 420.0,
      "notes": <String>["১০ অক্টোবর: কাশির সিরাপ ও অ্যান্টিবায়োটিক - ৪২০ ৳"]
    },
  ];

  List<Map<String, dynamic>> paymentRequests = [];
  List<Map<String, dynamic>> orderList = [];

  double todaySale = 0.0;
  double profitMargin = 12.0;
  double monthlyTarget = 300000.0;
  double currentMonthAchieved = 145000.0;

  // বাংলাদেশ ওষুধ ডাটাবেস
  List<Map<String, String>> medicineDatabase = [
    {"name": "Seclo 20mg", "generic": "Omeprazole", "company": "Square", "type": "Capsule"},
    {"name": "Sergel 20mg", "generic": "Esomeprazole", "company": "Healthcare", "type": "Capsule"},
    {"name": "Maxpro 20mg", "generic": "Esomeprazole", "company": "Renata", "type": "Capsule"},
    {"name": "Nexum 20mg", "generic": "Esomeprazole", "company": "Beximco", "type": "Tablet"},
    {"name": "Pantonix 20mg", "generic": "Pantoprazole", "company": "Incepta", "type": "Tablet"},
    {"name": "Finix 20mg", "generic": "Rabeprazole", "company": "Opsonin", "type": "Tablet"},
    {"name": "Napa 500mg", "generic": "Paracetamol", "company": "Beximco", "type": "Tablet"},
    {"name": "Napa Extra", "generic": "Paracetamol + Caffeine", "company": "Beximco", "type": "Tablet"},
    {"name": "Ace 500mg", "generic": "Paracetamol", "company": "Square", "type": "Tablet"},
    {"name": "Ace Plus", "generic": "Paracetamol + Caffeine", "company": "Square", "type": "Tablet"},
    {"name": "Fast 500mg", "generic": "Paracetamol", "company": "Acme", "type": "Tablet"},
    {"name": "Torax 10mg", "generic": "Ketorolac Tromethamine", "company": "Square", "type": "Tablet"},
    {"name": "Rolac 10mg", "generic": "Ketorolac Tromethamine", "company": "Renata", "type": "Tablet"},
    {"name": "Flamyd 400mg", "generic": "Metronidazole", "company": "Sanofi", "type": "Tablet"},
    {"name": "Azithrocin 500mg", "generic": "Azithromycin", "company": "Beximco", "type": "Tablet"},
    {"name": "Zimax 500mg", "generic": "Azithromycin", "company": "Square", "type": "Tablet"},
    {"name": "Cef-3 200mg", "generic": "Cefixime", "company": "Square", "type": "Capsule"},
    {"name": "Moxacil 500mg", "generic": "Amoxicillin", "company": "Square", "type": "Capsule"},
    {"name": "Alatrol 10mg", "generic": "Cetirizine HCl", "company": "Square", "type": "Tablet"},
    {"name": "Fexo 120mg", "generic": "Fexofenadine HCl", "company": "Square", "type": "Tablet"},
    {"name": "Monas 10mg", "generic": "Montelukast", "company": "Acme", "type": "Tablet"},
    {"name": "Tofen 1mg", "generic": "Ketotifen", "company": "Beximco", "type": "Syrup"},
    {"name": "Compath 5/500", "generic": "Metformin + Linagliptin", "company": "Square", "type": "Tablet"},
    {"name": "Bizoran 5/20", "generic": "Amlodipine + Olmesartan", "company": "Square", "type": "Tablet"},
    {"name": "Angilock 50mg", "generic": "Losartan Potassium", "company": "Square", "type": "Tablet"},
    {"name": "Ceevit 250mg", "generic": "Vitamin C", "company": "Square", "type": "Chewable"},
    {"name": "Bicozin", "generic": "Vitamin B Complex + Zinc", "company": "Square", "type": "Syrup"},
    {"name": "Calbo-D", "generic": "Calcium + Vitamin D3", "company": "Square", "type": "Tablet"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("সুলতান ফার্মেসি", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
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
          const NavigationDestination(icon: Icon(Icons.receipt_long), label: 'অর্ডার'),
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

  // ১. বাকি খাতা স্ক্রিন
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
              label: const Text("+ নতুন বাকি এন্ট্রি করুন", style: TextStyle(fontSize: 16)),
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
                      labelText: "মোবাইল নম্বর লিখুন",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
                    icon: const Icon(Icons.search),
                    label: const Text("বাকি ও হিসাব দেখুন"),
                    onPressed: () {
                      final p = searchPhoneController.text.trim();
                      Map<String, dynamic>? found;
                      for (var c in customers) {
                        if (c['phone'] == p) {
                          found = c;
                          break;
                        }
                      }
                      if (found != null) {
                        _showCustomerDueDetails(found);
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
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("বিকাশ ও নগদ পেমেন্ট নম্বর", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  Text("• বিকাশ: $bkashNumber", style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text("• নগদ: $nagadNumber", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("সকল বকেয়া তালিকা", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("মোট: ${customers.length} জন", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                final double dueVal = (c['due'] as num).toDouble();
                final List noteList = c['notes'] as List;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(c['name'].toString().isNotEmpty ? c['name'][0] : "?", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ),
                    title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("ফোন: ${c['phone']}\nনোট: ${noteList.isNotEmpty ? noteList.last : ''}"),
                    trailing: Text("৳ ${dueVal.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () => _showCustomerDueDetails(c),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text("পেন্ডিং পেমেন্ট রিকোয়েস্ট", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
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
                                double amt = (req['amount'] as num).toDouble();
                                for (var c in customers) {
                                  if (c['phone'] == p) {
                                    double curDue = (c['due'] as num).toDouble();
                                    c['due'] = (curDue - amt).clamp(0.0, double.infinity);
                                    (c['notes'] as List).add("অনলাইন পেমেন্ট অনুমোদিত: ৳ $amt (শেষ ৪: ${req['last4']})");
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
    final double dueVal = (cust['due'] as num).toDouble();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(cust['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
            Text("৳ ${dueVal.toStringAsFixed(0)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
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
                height: 90,
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
                              double cur = (cust['due'] as num).toDouble();
                              cust['due'] = cur + addAmt;
                              (cust['notes'] as List).add("নতুন বাকি: ৳ $addAmt (${addDueNoteController.text})");
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
                              double cur = (cust['due'] as num).toDouble();
                              cust['due'] = (cur - cashAmt).clamp(0.0, double.infinity);
                              (cust['notes'] as List).add("নগদ পরিশোধ: ৳ $cashAmt (${addDueNoteController.text})");
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
                const Text("বিকাশ/নগদে পরিশোধের তথ্য:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
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
        title: const Text("নতুন বাকি এন্ট্রি", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    "notes": <String>["${DateTime.now().day}/${DateTime.now().month}: ${noteC.text} (৳ ${amountC.text})"],
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

  // ২. ওষুধ ডিরেক্টরি
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
                      onPressed: () => _addNewMedicineDialog(),
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
                    filtered = medicineDatabase.where((m) {
                      final n = (m['name'] ?? '').toLowerCase();
                      final g = (m['generic'] ?? '').toLowerCase();
                      final c = (m['company'] ?? '').toLowerCase();
                      final s = val.toLowerCase();
                      return n.contains(s) || g.contains(s) || c.contains(s);
                    }).toList();
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
                        title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("জেনেরিক: ${item['generic']}\nকোম্পানি: ${item['company']}"),
                        trailing: Chip(label: Text(item['type'] ?? 'Tablet'), backgroundColor: Colors.teal.shade50),
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

  void _addNewMedicineDialog() {
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
              TextField(controller: companyC, decoration: const InputDecoration(labelText: "কোম্পানি (যেমন: Square)")),
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

  // ৩. অর্ডার স্ক্রিন
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
                  TextField(controller: noteController, maxLines: 2, decoration: const InputDecoration(labelText: "ওষুধের নাম ও বিবরণ")),
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

  // ৪. সেলস ও প্রফিট ট্র্যাকার
  Widget _buildSalesTargetScreen() {
    final saleC = TextEditingController();
    double netProfit = todaySale * (profitMargin / 100);
    double targetRemaining = (monthlyTarget - currentMonthAchieved).clamp(0.0, double.infinity);
    double progressPercent = monthlyTarget > 0 ? (currentMonthAchieved / monthlyTarget).clamp(0.0, 1.0) : 0.0;

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
    final passC = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAdmin ? "লগআউট" : "অ্যাডমিন লগইন"),
        content: isAdmin
            ? const Text("কাস্টমার মোডে ফিরে যেতে লগআউট চাপুন।")
            : TextField(controller: passC, obscureText: true, decoration: const InputDecoration(labelText: "পাসওয়ার্ড দিন")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (isAdmin) {
                setState(() => isAdmin = false);
                Navigator.pop(ctx);
              } else if (passC.text == adminPassword) {
                setState(() => isAdmin = true);
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ভুল পাসওয়ার্ড!")));
              }
            },
            child: Text(isAdmin ? "লগআউট" : "লগইন"),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("সুলতান ফার্মেসি যোগাযোগ"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.phone, color: Colors.green), title: const Text("সরাসরি কল"), subtitle: Text(helplineNumber)),
            ListTile(leading: const Icon(Icons.chat, color: Colors.teal), title: const Text("WhatsApp চ্যাট"), subtitle: Text(whatsappNumber)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ঠিক আছে"))],
      ),
    );
  }
}
