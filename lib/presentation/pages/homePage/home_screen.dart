import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/di/injection_container.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/presentation/blocs/home/home_bloc.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/dataCard_widget.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/genderGraph_widget.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/taxSummary_widget.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/tax_notification_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: DemozColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HomeError) {
                  return Center(child: Text(state.message));
                }

                if (state is HomeLoaded) {
                  return ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              DemozTex.home,
                              style: DemozTH.header4,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.settings,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 234,
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            mainAxisExtent: 113,
                          ),
                          children: [
                            dataCard(DemozColors.primaryBlue, DemozTex.noOfEmp,
                                state.employeeCount),
                            dataCard(DemozColors.lightGreen, "Income Tax Paid",
                                state.incomeTaxPaid.toInt()),
                            dataCard(
                                DemozColors.primaryBlue,
                                "Pension Tax Paid",
                                state.pensionTaxPaid.toInt()),
                            dataCard(
                                DemozColors.lightRed,
                                "Total Tax",
                                (state.incomeTaxPaid + state.pensionTaxPaid)
                                    .toInt()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          button(DemozTex.upcoming, () {
                            context
                                .read<HomeBloc>()
                                .add(const ToggleTimeFilter(true));
                          }, state.isUpcoming),
                          button(DemozTex.past, () {
                            context
                                .read<HomeBloc>()
                                .add(const ToggleTimeFilter(false));
                          }, !state.isUpcoming),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (state.isUpcoming && state.employeeCount > 0)
                        taxNotification(state)
                      else
                        const Center(child: Text("No history available")),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GenderGraphWidget(
                              maleCount: state.maleCount,
                              femaleCount: state.femaleCount,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: taxSummary())
                        ],
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}