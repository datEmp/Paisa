import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../data/accounts/data_sources/account_local_data_source.dart';
import '../../../data/category/data_sources/category_local_data_source.dart';
import '../../../data/expense/model/expense.dart';
import '../../summary/widgets/expense_item_widget.dart';
import '../../widgets/paisa_card.dart';

class AccountTransactionWidget extends StatelessWidget {
  const AccountTransactionWidget({
    Key? key,
    required this.accountLocalDataSource,
    required this.categoryLocalDataSource,
    required this.expenses,
  }) : super(key: key);

  final LocalAccountManagerDataSource accountLocalDataSource;
  final LocalCategoryManagerDataSource categoryLocalDataSource;
  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.money_off_rounded, size: 72),
              Text(AppLocalizations.of(context)!.emptyExpensesMessage),
            ],
          ),
        ),
      );
    }
    return ScreenTypeLayout(
      mobile: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            title: Text(
              AppLocalizations.of(context)!.transactionHistoryLabel,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(indent: 52, height: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (_, index) => ExpenseItemWidget(
              expense: expenses[index],
              account: accountLocalDataSource
                  .fetchAccount(expenses[index].accountId),
              category: categoryLocalDataSource
                  .fetchCategory(expenses[index].categoryId),
            ),
          ),
        ],
      ),
      tablet: ListView(
        padding: const EdgeInsets.only(
          bottom: 128,
          left: 8,
          right: 8,
        ),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              AppLocalizations.of(context)!.transactionHistoryLabel,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          PaisaCard(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length,
              itemBuilder: (_, index) {
                return ExpenseItemWidget(
                  expense: expenses[index],
                  account: accountLocalDataSource
                      .fetchAccount(expenses[index].accountId),
                  category: categoryLocalDataSource
                      .fetchCategory(expenses[index].categoryId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
