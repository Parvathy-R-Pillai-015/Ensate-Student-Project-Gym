import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/models/membership.dart';
import 'package:gymfit/screens/member/payment_screen.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  int? _selectedPlanId;
  bool _isLoading = false;

  // Mock data - replace with API call
  final List<MembershipPlan> _plans = [
    MembershipPlan(
      id: 1,
      name: 'Basic',
      description: 'Perfect for beginners',
      price: 29.99,
      durationDays: 30,
      benefits: [
        'Access to gym equipment',
        'Locker room access',
        'Free fitness assessment',
        '1 guest pass per month',
      ],
    ),
    MembershipPlan(
      id: 2,
      name: 'Standard',
      description: 'Most popular choice',
      price: 49.99,
      durationDays: 30,
      benefits: [
        'All Basic features',
        'Group fitness classes',
        'Personal trainer consultation',
        'Nutrition guidance',
        '2 guest passes per month',
      ],
    ),
    MembershipPlan(
      id: 3,
      name: 'Premium',
      description: 'Ultimate fitness experience',
      price: 79.99,
      durationDays: 30,
      benefits: [
        'All Standard features',
        '4 personal training sessions',
        'Advanced fitness tracking',
        'Priority class booking',
        'Towel service',
        'Unlimited guest passes',
      ],
    ),
    MembershipPlan(
      id: 4,
      name: 'Annual Basic',
      description: 'Best value - Save 20%',
      price: 287.90,
      durationDays: 365,
      benefits: [
        'Access to gym equipment',
        'Locker room access',
        'Free fitness assessment',
        '1 guest pass per month',
        'Save \$71.98 annually',
      ],
    ),
    MembershipPlan(
      id: 5,
      name: 'Annual Premium',
      description: 'Ultimate annual package',
      price: 767.90,
      durationDays: 365,
      benefits: [
        'All Premium features',
        '48 personal training sessions',
        'Advanced fitness tracking',
        'Priority class booking',
        'Towel service',
        'Unlimited guest passes',
        'Save \$191.98 annually',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConfig.primaryColor,
                  ThemeConfig.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.card_membership,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Invest in Your Fitness Journey',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the perfect plan for your goals',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Plans List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                final isSelected = _selectedPlanId == plan.id;
                final isAnnual = plan.durationDays == 365;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlanId = plan.id;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? ThemeConfig.primaryColor
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? ThemeConfig.primaryColor.withOpacity(0.05)
                          : Colors.white,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: ThemeConfig.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan.name,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? ThemeConfig.primaryColor
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          plan.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio<int>(
                                    value: plan.id,
                                    groupValue: _selectedPlanId,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPlanId = value;
                                      });
                                    },
                                    activeColor: ThemeConfig.primaryColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${plan.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeConfig.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      '/ ${plan.durationType}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              ...plan.benefits.map((benefit) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: ThemeConfig.successColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          benefit,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        if (isAnnual)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeConfig.successColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'SAVE 20%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedPlanId != null && !_isLoading
                      ? () => _proceedToPayment()
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _selectedPlanId != null
                              ? 'Continue to Payment'
                              : 'Select a Plan',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    final selectedPlan = _plans.firstWhere((plan) => plan.id == _selectedPlanId);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(plan: selectedPlan),
      ),
    );
  }
}
