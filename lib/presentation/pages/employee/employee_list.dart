import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/presentation/pages/employee/add_employee.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 21),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DemozTex.emp,
                        style: DemozTH.header4.copyWith(fontSize: 24),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.file_upload_outlined),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(DemozTex.uploadCSV),
                          ),
                        ],
                      )
                    ],
                  ),
                  addEmployee(context),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Widget addEmployee(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EmployeeAdd(),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DemozColors.lightGreen,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: DemozColors.white,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: DemozColors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DemozTex.addEmployee,
            style: DemozTH.body2Regular
                .copyWith(color: DemozColors.white, fontSize: 16),
          )
        ],
      ),
    ),
  );
}
