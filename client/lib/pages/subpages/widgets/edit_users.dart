import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/employees.module.dart';
import 'package:soul_connection/provider/assign.customers.service.dart';
import 'package:soul_connection/theme/color.dart';

class EditCustomers extends StatefulWidget {
  const EditCustomers({
    super.key,
    required this.employee,
    required this.permission,
  });
  final EmployeeModel employee;
  final bool permission;

  @override
  State<EditCustomers> createState() => _EditCustomersState();
}

class _EditCustomersState extends State<EditCustomers> {
  List<int> selectedCustomers = [];
  List<int> initialAssignedCustomers = [];

  @override
  void initState() {
    super.initState();
    selectedCustomers = List<int>.from(widget.employee.assignedCustomer);
    initialAssignedCustomers = List<int>.from(widget.employee.assignedCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: dw(context),
        height: dh(context),
        color: Colors.white,
        child: Column(
          children: [
            sh(40),
            const Text(
              'Edit list',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            sh(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 1.5,
                color: Colors.black,
                width: dw(context),
              ),
            ),
            SizedBox(
              width: 250,
              height: dh(context) - (user!.work != 'Coach' ? 230 : 150),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allCustomers.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      width: 250,
                      height: 30,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            width: 200,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${allCustomers[index].name} ${allCustomers[index].surname}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: selectedCustomers
                                .contains(allCustomers[index].userId),
                            activeColor: AppColor.deepblue,
                            onChanged: (bool? value) {
                              if (!widget.permission) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xff748bff),
                                    content: Text(
                                        'You do not have permission to edit customers'),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                if (value == true) {
                                  selectedCustomers
                                      .add(allCustomers[index].userId);
                                } else {
                                  selectedCustomers
                                      .remove(allCustomers[index].userId);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            sh(20),
            if (user!.work != 'Coach')
              GestureDetector(
                onTap: () async {
                  List<int> toAssign = [];
                  List<int> toUnassign = [];

                  for (int customerId in selectedCustomers) {
                    if (!initialAssignedCustomers.contains(customerId)) {
                      toAssign.add(customerId);
                    }
                  }

                  for (int customerId in initialAssignedCustomers) {
                    if (!selectedCustomers.contains(customerId)) {
                      toUnassign.add(customerId);
                    }
                  }

                  if (toAssign.isNotEmpty) {
                    final assignResult = await AssignCustomers.assignEmployee(
                        toAssign, widget.employee.id);
                    if (assignResult == 'Successfully assigned') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Color(0xff748bff),
                            content: Text('Customers assigned successfully!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Color(0xff748bff),
                            content: Text(assignResult)),
                      );
                    }
                  }

                  if (toUnassign.isNotEmpty) {
                    final unassignResult =
                        await AssignCustomers.unAssignEmployee(
                            toUnassign, widget.employee.id);
                    if (unassignResult == 'Successfully assigned') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Color(0xff748bff),
                            content:
                                Text('Customers unassigned successfully!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Color(0xff748bff),
                            content: Text(unassignResult)),
                      );
                    }
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.black, width: 1.5),
                  ),
                  width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            sh(20)
          ],
        ),
      ),
    );
  }
}
