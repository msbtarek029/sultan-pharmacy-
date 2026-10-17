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
          seedColor: const Color(0xFF00897B),
          primary: const Color(0xFF00897B),
          secondary: const Color(0xFFFF8F00),
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

  // নোটিশ
  String noticeText = "সুলতান ফার্মেসিতে স্বাগতম! যেকোনো ওষুধ ও প্রেসক্রিপশন অর্ডারে পাবেন আকর্ষণীয় ছাড়। বিকাশ বা নগদে বাকি পরিশোধ করতে পারবেন ঘরে বসেই।";

  // কাস্টমারদের বাকি তালিকা
  Map<String, double> customerDues = {
    "01700000000": 850.0,
    "01800000000": 1420.0,
    "01900000000": 320.0,
  };

  // পেমেন্ট রিকোয়েস্ট তালিকা
  List<Map<String, dynamic>> paymentRequests = [];

  // প্রেসক্রিপশন অর্ডার তালিকা
  List<Map<String, dynamic>> orderList = [];

  // ডেইলি সেলস ও প্রফিট
  double todaySale = 0.0;
  double profitMargin = 12.0; // ১২%
  double monthlyTarget = 300000.0; // ৩ লাখ টাকা
  double currentMonthAchieved = 145000.0;

  // DIMS স্টাইল ওষুধ ডাটাবেস
  List<Map<String, String>> medicineDatabase = [
    {"name": "Napa 500mg", "generic": "Paracetamol", "company": "Beximco Pharmaceuticals", "type": "Tablet"},
    {"name": "Ace Plus", "generic": "Paracetamol + Caffeine", "company": "Square Pharmaceuticals", "type": "Tablet"},
    {"name": "Seclo 20mg", "generic": "Omeprazole", "company": "Square Pharmaceuticals", "type": "Capsule"},
    {"name": "Sergel 20mg", "generic": "Esomeprazole", "company": "Healthcare Pharmaceuticals", "type": "Capsule"},
    {"name": "Alatrol 10mg", "generic": "Cetirizine Dihydrochloride", "company": "Square Pharmaceuticals", "type": "Tablet"},
    {"name": "Fexo 120mg", "generic": "Fexofenadine HCl", "company": "Square Pharmaceuticals", "type": "Tablet"},
    {"name": "Monas 10mg", "generic": "Montelukast", "company": "Acme Laboratories", "type": "Tablet"},
    {"name": "Ceevit 250mg", "generic": "Vitamin C", "company": "Square Pharmaceuticals", "type": "Chewable Tablet"},
    {"name": "Azithrocin 500mg", "generic": "Azithromycin", "company": "Beximco Pharmaceuticals", "type": "Tablet"},
    {"name": "Maxpro 20mg", "generic": "Esomeprazole", "company": "Renata Limited", "type": "Capsule"},
    {"name": "Tofen 1mg", "generic": "Ketotifen", "company": "Beximco Pharmaceuticals", "type": "Syrup"},
    {"name": "Flamyd 400mg", "generic": "Metronidazole", "company": "Sanofi Bangladesh", "type": "Tablet"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_pharmacy, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Sultan Pharmacy",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00897B),
        actions: [
          IconButton(
            tooltip: "যোগাযোগ / WhatsApp",
            icon: const Icon(Icons.phone_in_talk, color: Colors.white),
            onPressed: () => _showContactDialog(),
          ),
          IconButton(
            tooltip: "ভার্সন ও আপডেট",
            icon: const Icon(Icons.system_update_alt, color: Colors.white),
            onPressed: () => _showUpdateDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'toggleAdmin') {
                _showAdminLoginDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggleAdmin',
                child: Text(isAdmin ? "কাস্টমার মোড" : "অ্যাডমিন লগইন"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // নোটিশ বোর্ড
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.amber.shade100,
            child: Row(
              children: [
                const Icon(Icons.campaign, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    noticeText,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _editNoticeDialog(),
                  )
              ],
            ),
          ),
          Expanded(
            child: _getSelectedPage(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'বাকি খাতা'),
          const NavigationDestination(icon: Icon(Icons.medication), label: 'ওষুধ তালিকা'),
          const NavigationDestination(icon: Icon(Icons.receipt_long), label: 'অর্ডার ও প্রেসক্রিপশন'),
          if (isAdmin)
            const NavigationDestination(icon: Icon(Icons.analytics), label: 'সেলস ও টার্গেট'),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    if (_currentIndex == 0) return _buildBakiScreen();
    if (_currentIndex == 1) return _buildMedicineDirectory();
    if (_currentIndex == 2) return _buildOrderScreen();
    if (_currentIndex == 3 && isAdmin) return _buildSalesTargetScreen();
    return _buildBakiScreen();
  }

  // ১. বাকি খাতা স্ক্রিন
  Widget _buildBakiScreen() {
    final phoneController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("আপনার বাকি হিসাব চেক করুন", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "মোবাইল নম্বর লিখুন",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.search),
                    label: const Text("বাকি দেখুন"),
                    onPressed: () {
                      final p = phoneController.text.trim();
                      if (customerDues.containsKey(p)) {
                        _showDueDetailsDialog(p, customerDues[p]!);
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
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: Icon(Icons.payment, color: Colors.teal, size: 40),
              title: Text("বিকাশ / নগদ পেমেন্ট নম্বর", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("bKash Personal: 01700-000000\nNagad Personal: 01800-000000\n(টাকা পাঠিয়ে শেষ ৪ ডিজিট সাবমিট করুন)"),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 20),
            const Text("পেন্ডিং পেমেন্ট রিকোয়েস্ট (অ্যাডমিন)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            paymentRequests.isEmpty
                ? const Text("বর্তমানে কোনো পেন্ডিং পেমেন্ট রিকোয়েস্ট নেই।")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentRequests.length,
                    itemBuilder: (context, index) {
                      final item = paymentRequests[index];
                      return Card(
                        child: ListTile(
                          title: Text("নম্বর: ${item['phone']} | ৳ ${item['amount']}"),
                          subtitle: Text("শেষ ৪ ডিজিট: ${item['last4']}"),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                String p = item['phone'];
                                double amt = item['amount'];
                                if (customerDues.containsKey(p)) {
                                  customerDues[p] = (customerDues[p]! - amt).clamp(0, double.infinity);
                                }
                                paymentRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("পেমেন্ট সফলভাবে অ্যাপ্রুভ হয়েছে এবং বাকি থেকে বাদ পড়েছে!")),
                              );
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

  void _showDueDetailsDialog(String phone, double due) {
    final amountController = TextEditingController();
    final last4Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("মোবাইল: $phone"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("মোট বকেয়া: ৳ ${due.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
            const Divider(),
            const Text("বিকাশ বা নগদে টাকা পাঠিয়েছেন? নিচে তথ্য দিন:"),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "কত টাকা পাঠিয়েছেন?")),
            TextField(controller: last4Controller, keyboardType: TextInputType.number, maxLength: 4, decoration: const InputDecoration(labelText: "নম্বরের শেষ ৪ ডিজিট")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বন্ধ করুন")),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty && last4Controller.text.length == 4) {
                setState(() {
                  paymentRequests.add({
                    "phone": phone,
                    "amount": double.tryParse(amountController.text) ?? 0.0,
                    "last4": last4Controller.text,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("পেমেন্ট রিকোয়েস্ট পাঠানো হয়েছে! অ্যাডমিন যাচাই করে অ্যাপ্রুভ করবেন।")));
              }
            },
            child: const Text("সাবমিট করুন"),
          ),
        ],
      ),
    );
  }

  // ২. DIMS স্টাইল ওষুধ সার্চ স্ক্রিন
  Widget _buildMedicineDirectory() {
    TextEditingController searchController = TextEditingController();
    List<Map<String, String>> filtered = List.from(medicineDatabase);

    return StatefulBuilder(
      builder: (context, setDirectoryState) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "ওষুধের নাম বা জেনেরিক দিয়ে খুঁজুন...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (val) {
                  setDirectoryState(() {
                    filtered = medicineDatabase.where((m) =>
                        m['name']!.toLowerCase().contains(val.toLowerCase()) ||
                        m['generic']!.toLowerCase().contains(val.toLowerCase())).toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      elevation: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: const Icon(Icons.medical_services, color: Colors.teal),
                        ),
                        title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  // ৩. প্রেসক্রিপশন ও ওষুধ অর্ডার
  Widget _buildOrderScreen() {
    final noteController = TextEditingController();
    final phoneController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("প্রেসক্রিপশন আপলোড বা ওষুধের নাম লিখে অর্ডার দিন", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(controller: phoneController, decoration: const InputDecoration(labelText: "আপনার মোবাইল নম্বর")),
                  const SizedBox(height: 12),
                  TextField(controller: noteController, maxLines: 3, decoration: const InputDecoration(labelText: "প্রয়োজনীয় ওষুধের নাম ও পরিমাণ লিখুন")),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("প্রেসক্রিপশনের ছবি তুলুন"),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ক্যামেরা চালু হয়েছে (প্রেসক্রিপশন সিলেক্টেড)")));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B), foregroundColor: Colors.white),
                      onPressed: () {
                        if (phoneController.text.isNotEmpty) {
                          setState(() {
                            orderList.add({
                              "phone": phoneController.text,
                              "note": noteController.text,
                              "status": "Pending",
                            });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("অর্ডার পাঠানো হয়েছে! দোকান থেকে শীঘ্রই যোগাযোগ করা হবে।")));
                          phoneController.clear();
                          noteController.clear();
                        }
                      },
                      child: const Text("অর্ডার কনফার্ম করুন"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("সাম্প্রতিক অর্ডারসমূহ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          orderList.isEmpty
              ? const Text("এখনো কোনো অর্ডার জমা পড়েনি।")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    final ord = orderList[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt, color: Colors.teal),
                        title: Text("নম্বর: ${ord['phone']}"),
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

  // ৪. সেলস, প্রফিট ও টার্গেট ট্র্যাকার (অ্যাডমিন অনলি)
  Widget _buildSalesTargetScreen() {
    final saleController = TextEditingController();
    double netProfit = todaySale * (profitMargin / 100);
    double targetRemaining = (monthlyTarget - currentMonthAchieved).clamp(0, double.infinity);
    double progressPercent = (currentMonthAchieved / monthlyTarget).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Card(
            color: Colors.teal.shade800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("আজকের সেলস ও লাভ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("মোট বিক্রি: ৳ ${todaySale.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  Text("লাভ ($profitMargin%): ৳ ${netProfit.toStringAsFixed(2)}", style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("দৈনিক বিক্রি ইনপুট দিন", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(controller: saleController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "আজকের মোট বিক্রি (৳)")),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("প্রফিট মার্জিন:"),
                      DropdownButton<double>(
                        value: profitMargin,
                        items: [10.0, 12.0, 15.0, 18.0, 20.0].map((v) => DropdownMenuItem(value: v, child: Text("$v%"))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => profitMargin = val);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B), foregroundColor: Colors.white),
                    onPressed: () {
                      if (saleController.text.isNotEmpty) {
                        setState(() {
                          todaySale = double.tryParse(saleController.text) ?? 0.0;
                          currentMonthAchieved += todaySale;
                        });
                        saleController.clear();
                      }
                    },
                    child: const Text("বিক্রি সেভ করুন"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("মাসিক টার্গেট ট্র্যাকার", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progressPercent, minHeight: 12, borderRadius: BorderRadius.circular(6)),
                  const SizedBox(height: 10),
                  Text("টার্গেট: ৳ ${monthlyTarget.toStringAsFixed(0)}"),
                  Text("অর্জিত: ৳ ${currentMonthAchieved.toStringAsFixed(0)} (${(progressPercent * 100).toStringAsFixed(1)}%)"),
                  Text("টার্গেট থেকে পিছিয়ে আছেন: ৳ ${targetRemaining.toStringAsFixed(0)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdminLoginDialog() {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAdmin ? "লগআউট নিশ্চিত করুন" : "অ্যাডমিন পাসওয়ার্ড দিন"),
        content: isAdmin
            ? const Text("আপনি কি কাস্টমার মোডে ফিরে যেতে চান?")
            : TextField(controller: passController, obscureText: true, decoration: const InputDecoration(labelText: "পাসওয়ার্ড (ডিফল্ট: 1234)")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (isAdmin) {
                setState(() => isAdmin = false);
                Navigator.pop(ctx);
              } else if (passController.text == "1234") {
                setState(() => isAdmin = true);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("অ্যাডমিন হিসেবে লগইন সফল!")));
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

  void _editNoticeDialog() {
    final noticeController = TextEditingController(text: noticeText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("নোটিশ পরিবর্তন করুন"),
        content: TextField(controller: noticeController, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              setState(() => noticeText = noticeController.text);
              Navigator.pop(ctx);
            },
            child: const Text("সেভ করুন"),
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: Icon(Icons.call, color: Colors.green), title: Text("সরাসরি কল"), subtitle: Text("01700-000000")),
            ListTile(leading: Icon(Icons.chat, color: Colors.teal), title: Text("WhatsApp চ্যাট"), subtitle: Text("01700-000000")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ঠিক আছে")),
        ],
      ),
    );
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Colors.teal),
            SizedBox(width: 8),
            Text("অ্যাপ আপডেট"),
          ],
        ),
        content: const Text("আপনি সুলতান ফার্মেসি অ্যাপের সর্বশেষ ভার্সন (v1.0.0) ব্যবহার করছেন। নতুন কোনো আপডেট আসলে এখানে নোটিফিকেশন পাবেন।"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বন্ধ করুন")),
        ],
      ),
    );
  }
}
