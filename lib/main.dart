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

  // বর্তমান লগইন করা কাস্টমারের তথ্য
  String? currentCustomerPhone;
  String? currentCustomerName;

  // সিকিউরিটি ও সেটিংস
  String adminPassword = "1234";
  final String masterRecoveryPin = "7788";
  String bkashNumber = "01700-000000 (Personal)";
  String nagadNumber = "01800-000000 (Personal)";
  String helplineNumber = "01700-000000";
  String whatsappNumber = "01700-000000";
  String noticeText = "সুলতান ফার্মেসিতে স্বাগতম! ঘরে বসেই যেকোনো ওষুধ অর্ডার ও স্বাস্থ্যসেবা বুকিং করতে পারবেন।";

  // কাস্টমার ডাটাবেস
  List<Map<String, dynamic>> customers = [
    {
      "name": "আব্দুর রহিম",
      "phone": "01711111111",
      "due": 1250.0,
      "visits": 14,
      "notes": <String>["১৫ অক্টোবর: প্রেসারের ওষুধ - ৫০০ ৳", "১৮ অক্টোবর: নাপা ও গ্যাস্ট্রিক - ৭৫০ ৳"]
    },
    {
      "name": "মো: রফিকুল ইসলাম",
      "phone": "01822222222",
      "due": 840.0,
      "visits": 8,
      "notes": <String>["১২ অক্টোবর: ইনসুলিন ও সুগারের ওষুধ - ৮৪০ ৳"]
    },
  ];

  // রিসাইকেল বিন
  List<Map<String, dynamic>> recycleBin = [];

  // ফার্মেসির সেবা তালিকা
  List<Map<String, dynamic>> services = [
    {"title": "ওষুধ হোম ডেলিভারি", "price": 30.0, "desc": "জরুরি ওষুধ আধা ঘণ্টার মধ্যে বাসায় পৌঁছে দেওয়া হয়।"},
    {"title": "ব্লাড প্রেশার (BP) চেক", "price": 20.0, "desc": "ডিজিটাল ও ম্যানুয়াল মেশিনে নিখুঁত প্রেশার মাপা হয়।"},
    {"title": "ডায়াবেটিস / সুগার টেস্ট", "price": 50.0, "desc": "ইনস্ট্যান্ট ওয়ান-টাচ গ্লুকোমিটার দিয়ে সুগার টেস্ট।"},
    {"title": "নেবুলাইজার সেবা", "price": 100.0, "desc": "অ্যাজমা ও শ্বাসকষ্টের জন্য জরুরি নেবুলাইজার সাপোর্ট।"},
    {"title": "জরুরি ফার্স্ট এইড ও ড্রেসিং", "price": 150.0, "desc": "ক্ষত ও কাটা-ছেঁড়ার জীবাণুমুক্ত ব্যান্ডেজ সেবা।"},
    {"title": "ওজন ও বিএমআই পরিমাপ", "price": 10.0, "desc": "সঠিক ওজন ও শারীরিক স্বাস্থ্য মাপ যাচাই।"},
  ];

  List<Map<String, dynamic>> serviceRequests = [];
  List<Map<String, dynamic>> orderList = [];
  List<Map<String, dynamic>> paymentRequests = [];

  // সেলস ও হিসাব
  double todaySale = 0.0;
  double profitMargin = 12.0;
  double monthlyTarget = 300000.0;
  double currentMonthAchieved = 145000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("সুলতান ফার্মেসি", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text(
              currentCustomerPhone != null 
                  ? "কাস্টমার: $currentCustomerName ($currentCustomerPhone)"
                  : "ডিজিটাল ফার্মেসি ও কাস্টমার সেবা",
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00796B),
        actions: [
          IconButton(
            tooltip: "হেল্পলাইন",
            icon: const Icon(Icons.support_agent, color: Colors.white),
            onPressed: () => _showContactDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (val) {
              if (val == 'admin') _showAdminAuthDialog();
              if (val == 'customer_login') _showCustomerLoginDialog();
              if (val == 'customer_logout') {
                setState(() {
                  currentCustomerPhone = null;
                  currentCustomerName = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("কাস্টমার লগআউট হয়েছে")));
              }
              if (val == 'recovery') _showPasswordRecoveryDialog();
            },
            itemBuilder: (context) => [
              if (currentCustomerPhone == null)
                const PopupMenuItem(value: 'customer_login', child: Text("কাস্টমার লগইন")),
              if (currentCustomerPhone != null)
                const PopupMenuItem(value: 'customer_logout', child: Text("কাস্টমার লগআউট")),
              PopupMenuItem(value: 'admin', child: Text(isAdmin ? "লগআউট (অ্যাডমিন মোড)" : "অ্যাডমিন লগইন")),
              const PopupMenuItem(value: 'recovery', child: Text("পাসওয়ার্ড রিকভারি")),
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
          const NavigationDestination(icon: Icon(Icons.medical_services), label: 'ফার্মেসি সেবা'),
          const NavigationDestination(icon: Icon(Icons.receipt_long), label: 'ওষুধ অর্ডার'),
          const NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'বাকি খাতা'),
          if (isAdmin) const NavigationDestination(icon: Icon(Icons.analytics), label: 'সেলস হিসাব'),
          if (isAdmin) const NavigationDestination(icon: Icon(Icons.restore_from_trash), label: 'রিসাইকেল বিন'),
          if (isAdmin) const NavigationDestination(icon: Icon(Icons.settings), label: 'সেটিংস'),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (_currentIndex) {
      case 0: return _buildServicesScreen();
      case 1: return _buildOrderScreen();
      case 2: return _buildBakiScreen();
      case 3: return isAdmin ? _buildSalesTargetScreen() : _buildServicesScreen();
      case 4: return isAdmin ? _buildRecycleBinScreen() : _buildServicesScreen();
      case 5: return isAdmin ? _buildSettingsScreen() : _buildServicesScreen();
      default: return _buildServicesScreen();
    }
  }

  // ================= ১. ফার্মেসির সেবা ও বুকিং স্ক্রিন (সবার জন্য) =================
  Widget _buildServicesScreen() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          if (currentCustomerPhone == null)
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.teal, size: 36),
                title: const Text("আপনার মোবাইল নম্বর দিয়ে যুক্ত হোন", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("সহজেই ওষুধ অর্ডার ও সেবা বুকিং করতে লগইন করুন।"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                  onPressed: () => _showCustomerLoginDialog(),
                  child: const Text("লগইন"),
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (isAdmin) ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
              icon: const Icon(Icons.add),
              label: const Text("+ নতুন সেবা ও ফি যোগ করুন"),
              onPressed: () => _addNewServiceDialog(),
            ),
            const SizedBox(height: 10),
          ],
          const Text("আমাদের স্বাস্থ্যসেবা ও ফি তালিকা", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final s = services[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: const Icon(Icons.health_and_safety, color: Colors.teal),
                  ),
                  title: Text(s['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${s['desc']}\nচার্জ: ৳ ${(s['price'] as num).toStringAsFixed(0)}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: () => _bookServiceDialog(s['title']),
                    child: const Text("বুক করুন"),
                  ),
                ),
              );
            },
          ),
          if (isAdmin) ...[
            const SizedBox(height: 16),
            const Text("কাস্টমারদের সেবা বুকিং রিকোয়েস্ট (অ্যাডমিন)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            serviceRequests.isEmpty
                ? const Text("বর্তমানে কোনো সার্ভিস রিকোয়েস্ট নেই।", style: TextStyle(color: Colors.grey))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: serviceRequests.length,
                    itemBuilder: (context, index) {
                      final req = serviceRequests[index];
                      return Card(
                        color: Colors.teal.shade50,
                        child: ListTile(
                          title: Text("${req['service']} (ফোন: ${req['phone']})"),
                          subtitle: Text("সময়/নোট: ${req['time']}\nস্ট্যাটাস: ${req['status']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                tooltip: "এক্সেপ্ট",
                                onPressed: () {
                                  setState(() => req['status'] = "গৃহীত (রেডি)");
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                tooltip: "রিজেক্ট",
                                onPressed: () {
                                  setState(() => req['status'] = "বাতিল");
                                },
                              ),
                            ],
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

  // ================= ২. ওষুধ ও প্রেসক্রিপশন অর্ডার স্ক্রিন (সবার জন্য) =================
  Widget _buildOrderScreen() {
    final noteController = TextEditingController();
    final phoneController = TextEditingController(text: currentCustomerPhone ?? "");

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("যেকোনো ওষুধ বা প্রেসক্রিপশন অর্ডার করুন", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("দোকানে আসা ছাড়া ঘরে বসেই প্রয়োজনীয় ওষুধ লিখে বা প্রেসক্রিপশন পাঠিয়ে দিন।", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "আপনার মোবাইল নম্বর")),
                  const SizedBox(height: 10),
                  TextField(controller: noteController, maxLines: 3, decoration: const InputDecoration(labelText: "প্রয়োজনীয় ওষুধের নাম ও পরিমাণ লিখুন")),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("প্রেসক্রিপশনের ছবি সিলেক্ট করুন"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ক্যামেরা/ছবি এটাচ করা হয়েছে")));
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                      onPressed: () {
                        if (phoneController.text.isNotEmpty) {
                          setState(() {
                            orderList.add({
                              "phone": phoneController.text,
                              "note": noteController.text,
                              "status": "পেন্ডিং",
                              "adminMsg": "যাচাই করা হচ্ছে",
                            });
                          });
                          noteController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("অর্ডার পাঠানো হয়েছে! দোকান থেকে শীঘ্রই মেসেজ দেওয়া হবে।")));
                        }
                      },
                      child: const Text("অর্ডার কনফার্ম করুন"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("আপনার অর্ডারসমূহের তালিকা", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          orderList.isEmpty
              ? const Text("বর্তমানে কোনো অর্ডার জমা পড়েনি।", style: TextStyle(color: Colors.grey))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    final ord = orderList[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.local_shipping, color: Colors.teal),
                        title: Text("ফোন: ${ord['phone']} | অবস্থা: ${ord['status']}"),
                        subtitle: Text("ওষুধ: ${ord['note']}\nদোকানের মেসেজ: ${ord['adminMsg']}"),
                        trailing: isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.edit_note, color: Colors.teal),
                                tooltip: "মেসেজ দিন",
                                onPressed: () => _adminOrderReplyDialog(ord),
                              )
                            : null,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // ================= ৩. বাকি খাতা (যাদের বাকি আছে তাদের জন্য + সাধারণ কাস্টমার ভিউ) =================
  Widget _buildBakiScreen() {
    final searchPhoneController = TextEditingController(text: currentCustomerPhone ?? "");

    // বর্তমান লগইন কাস্টমারের বাকি তথ্য
    Map<String, dynamic>? myRecord;
    if (currentCustomerPhone != null) {
      for (var c in customers) {
        if (c['phone'] == currentCustomerPhone) {
          myRecord = c;
          break;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          // যদি কাস্টমার লগইন করা থাকে এবং তার কোনো বাকি না থাকে:
          if (currentCustomerPhone != null) ...[
            Card(
              color: (myRecord != null && (myRecord['due'] as num) > 0) ? Colors.red.shade50 : Colors.green.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      (myRecord != null && (myRecord['due'] as num) > 0) ? Icons.warning : Icons.check_circle,
                      color: (myRecord != null && (myRecord['due'] as num) > 0) ? Colors.red : Colors.green,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      myRecord != null && (myRecord['due'] as num) > 0
                          ? "আপনার বর্তমান বকেয়া বাকি: ৳ ${(myRecord['due'] as num).toStringAsFixed(0)}"
                          : "আলহামদুলিল্লাহ! আপনার কোনো বকেয়া বাকি নেই (৳ ০)",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: (myRecord != null && (myRecord['due'] as num) > 0) ? Colors.red : Colors.green.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (myRecord != null && (myRecord['due'] as num) > 0) ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                        onPressed: () => _showCustomerDueDetails(myRecord!),
                        child: const Text("বাকি পরিশোধ করুন (বিকাশ/নগদ)"),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

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
            const SizedBox(height: 12),
          ],

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const Text("যেকোনো কাস্টমারের হিসাব অনুসন্ধান", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    label: const Text("বাকি হিসাব দেখুন"),
                    onPressed: () {
                      final p = searchPhoneController.text.trim();
                      Map<String, dynamic>? found;
                      for (var c in customers) {
                        if (c['phone'] == p) {
                          found = c;
                          setState(() {
                            int v = (c['visits'] as num).toInt();
                            c['visits'] = v + 1;
                          });
                          break;
                        }
                      }
                      if (found != null) {
                        _showCustomerDueDetails(found);
                      } else {
                        // যদি কাস্টমারের কোনো বাকি না থাকে
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("নম্বর: $p"),
                            content: const Text("এই নম্বরে কোনো বকেয়া বাকি নেই! মোট বাকি: ৳ ০", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ঠিক আছে"))],
                          ),
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
                  const Text("দোকানের বিকাশ ও নগদ নম্বর", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                const Text("সকল কাস্টমার তালিকা", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                final int visitCount = (c['visits'] as num).toInt();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(c['name'].toString().isNotEmpty ? c['name'][0] : "?", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ),
                    title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("ফোন: ${c['phone']}\nভিজিট: $visitCount বার"),
                    trailing: Text("৳ ${dueVal.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () => _showCustomerDueDetails(c),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // কাস্টমার ওয়ান-ট্যাপ লগইন ডায়ালগ
  void _showCustomerLoginDialog() {
    final phoneC = TextEditingController();
    final nameC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("কাস্টমার লগইন / যুক্ত হোন"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "আপনার নাম")),
            TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "মোবাইল নম্বর")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
            onPressed: () {
              if (phoneC.text.isNotEmpty) {
                String p = phoneC.text.trim();
                String n = nameC.text.trim().isEmpty ? "কাস্টমার" : nameC.text.trim();

                // কাস্টমার আগে থেকেই আছে কিনা চেক করা
                bool exists = false;
                for (var c in customers) {
                  if (c['phone'] == p) {
                    exists = true;
                    n = c['name'];
                    int v = (c['visits'] as num).toInt();
                    c['visits'] = v + 1;
                    break;
                  }
                }
                // না থাকলে নতুন কাস্টমার হিসেবে যুক্ত করা (বাকি ০)
                if (!exists) {
                  customers.add({
                    "name": n,
                    "phone": p,
                    "due": 0.0,
                    "visits": 1,
                    "notes": <String>["কাস্টমার হিসেবে যুক্ত হয়েছেন"],
                  });
                }

                setState(() {
                  currentCustomerPhone = p;
                  currentCustomerName = n;
                });

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("স্বাগতম, $n!")));
              }
            },
            child: const Text("লগইন"),
          ),
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
    final int visits = (cust['visits'] as num).toInt();

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
              Text("মোট অ্যাপ ভিজিট: $visits বার", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
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
                TextField(controller: addDueNoteController, decoration: const InputDecoration(labelText: "নোট / বিবরণ")),
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
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text("ভুল এন্ট্রি কেটে রিসাইকেল বিনে পাঠান"),
                  onPressed: () {
                    double wrongAmt = double.tryParse(addDueAmountController.text) ?? 0.0;
                    if (wrongAmt > 0) {
                      setState(() {
                        double cur = (cust['due'] as num).toDouble();
                        cust['due'] = (cur - wrongAmt).clamp(0.0, double.infinity);
                        recycleBin.add({
                          "customerName": cust['name'],
                          "customerPhone": cust['phone'],
                          "amount": wrongAmt,
                          "note": addDueNoteController.text.isEmpty ? "ভুল এন্ট্রি" : addDueNoteController.text,
                          "date": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
                        });
                        (cust['notes'] as List).add("ভুল হিসাব রিসাইকেল বিনে পাঠানো হয়েছে: ৳ $wrongAmt");
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("হিসাবটি রিসাইকেল বিনে জমা হয়েছে!")));
                    }
                  },
                ),
              ] else if (dueVal > 0) ...[
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
                    "visits": 1,
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

  void _bookServiceDialog(String serviceName) {
    final phoneC = TextEditingController(text: currentCustomerPhone ?? "");
    final timeC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("সেবা বুকিং: $serviceName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "আপনার মোবাইল নম্বর")),
            TextField(controller: timeC, decoration: const InputDecoration(labelText: "কখন সেবাটি নিতে চান? (সময়)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (phoneC.text.isNotEmpty) {
                setState(() {
                  serviceRequests.add({
                    "service": serviceName,
                    "phone": phoneC.text,
                    "time": timeC.text.isEmpty ? "জরুরি" : timeC.text,
                    "status": "পেন্ডিং",
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("রিকোয়েস্ট পাঠানো হয়েছে!")));
              }
            },
            child: const Text("সাবমিট করুন"),
          ),
        ],
      ),
    );
  }

  void _addNewServiceDialog() {
    final titleC = TextEditingController();
    final priceC = TextEditingController();
    final descC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("নতুন সেবা যুক্ত করুন"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleC, decoration: const InputDecoration(labelText: "সেবার নাম")),
            TextField(controller: priceC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "সেবা ফি (৳)")),
            TextField(controller: descC, decoration: const InputDecoration(labelText: "বিবরণ")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (titleC.text.isNotEmpty && priceC.text.isNotEmpty) {
                setState(() {
                  services.add({
                    "title": titleC.text,
                    "price": double.tryParse(priceC.text) ?? 0.0,
                    "desc": descC.text,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("যুক্ত করুন"),
          ),
        ],
      ),
    );
  }

  void _adminOrderReplyDialog(Map<String, dynamic> ord) {
    final msgC = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("অর্ডার যাচাই ও মেসেজ"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: msgC, decoration: const InputDecoration(labelText: "মেসেজ (যেমন: ৪৫০ ৳ বিল, রেডি আছে)")),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                ord['status'] = "গৃহীত";
                ord['adminMsg'] = msgC.text.isEmpty ? "ওষুধ রেডি আছে।" : msgC.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text("Accept"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                ord['status'] = "বাতিল";
                ord['adminMsg'] = msgC.text.isEmpty ? "স্টকে নেই।" : msgC.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  // ================= ৪. সেলস ও মাসিক হিসাব =================
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

  // ================= ৫. রিসাইকেল বিন =================
  Widget _buildRecycleBinScreen() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("রিসাইকেল বিন", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("আইটেম: ${recycleBin.length} টি", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          recycleBin.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(30.0), child: Text("রিসাইকেল বিন সম্পূর্ণ খালি!")))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recycleBin.length,
                  itemBuilder: (context, index) {
                    final item = recycleBin[index];
                    return Card(
                      color: Colors.red.shade50,
                      child: ListTile(
                        title: Text("${item['customerName']} (${item['customerPhone']})"),
                        subtitle: Text("টাকা: ৳ ${item['amount']} | নোট: ${item['note']}\nতারিখ: ${item['date']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.settings_backup_restore, color: Colors.green),
                              tooltip: "কাস্টমারের আইডিতে ফেরত পাঠান",
                              onPressed: () {
                                setState(() {
                                  String p = item['customerPhone'];
                                  double amt = (item['amount'] as num).toDouble();
                                  for (var c in customers) {
                                    if (c['phone'] == p) {
                                      double curDue = (c['due'] as num).toDouble();
                                      c['due'] = curDue + amt;
                                      (c['notes'] as List).add("রিসাইকেল বিন থেকে পুনর্বহাল: ৳ $amt");
                                      break;
                                    }
                                  }
                                  recycleBin.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("টাকা কাস্টমারের আইডিতে আবার যোগ হয়েছে!")));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.red),
                              tooltip: "স্থায়ীভাবে মুছুন",
                              onPressed: () {
                                setState(() => recycleBin.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // ================= ৬. সেটিংস স্ক্রিন =================
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
                  TextField(controller: helplineC, decoration: const InputDecoration(labelText: "ফোন / WhatsApp নম্বর")),
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

  void _showPasswordRecoveryDialog() {
    final pinC = TextEditingController();
    final newPassC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("পাসওয়ার্ড উদ্ধার (Recovery)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("মাস্টার পিন দিন (ডিফল্ট: 7788):", style: TextStyle(fontSize: 12, color: Colors.grey)),
            TextField(controller: pinC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "মাস্টার রিকভারি পিন")),
            TextField(controller: newPassC, obscureText: true, decoration: const InputDecoration(labelText: "নতুন পাসওয়ার্ড লিখুন")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (pinC.text == masterRecoveryPin && newPassC.text.isNotEmpty) {
                setState(() => adminPassword = newPassC.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("পাসওয়ার্ড সফলভাবে পুনরুদ্ধার হয়েছে!")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ভুল রিকভারি পিন!")));
              }
            },
            child: const Text("রিসেট করুন"),
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
