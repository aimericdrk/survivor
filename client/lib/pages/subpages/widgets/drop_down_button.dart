import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/customer.module.dart';

class CustomerDropdown extends StatefulWidget {
  const CustomerDropdown({
    super.key,
    required this.onCustomerChange,
  });

  final Function(CustomerModel) onCustomerChange;

  @override
  CustomerDropdownState createState() => CustomerDropdownState();
}

class CustomerDropdownState extends State<CustomerDropdown> {
  late CustomerModel selectedCustomer;

  @override
  void initState() {
    super.initState();
    selectedCustomer = filteredCustomers.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xffeaeef6), width: 2),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              sw(30),
              const Text(
                'Customer :',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: '${selectedCustomer.name} ${selectedCustomer.surname}',
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 26,
                  elevation: 16,
                  padding: const EdgeInsets.only(left: 5),
                  focusColor: const Color(0xfff2f2f2),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCustomer =
                          filteredCustomers.where((CustomerModel customer) {
                        return '${customer.name} ${customer.surname}' == value;
                      }).first;
                      widget.onCustomerChange(selectedCustomer);
                    });
                  },
                  items: filteredCustomers
                      .map((CustomerModel customer) =>
                          '${customer.name} ${customer.surname}')
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              width: 2,
              margin: const EdgeInsets.only(right: 25),
              color: const Color(0xffeaeef6),
            ),
          )
        ],
      ),
    );
  }
}
