import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/common.dart';
import '../../../data/accounts/model/account.dart';
import '../../../data/expense/model/expense.dart';
import '../../../service_locator.dart';
import '../../widgets/future_resolve.dart';
import '../../widgets/paisa_empty_widget.dart';
import '../bloc/accounts_bloc.dart';
import 'accounts_mobile_page.dart';
import 'accounts_tablet_page.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureResolve<AccountsBloc>(
      future: locator.getAsync<AccountsBloc>(),
      builder: (value) {
        final AccountsBloc accountsBloc = value;
        return Material(
          key: const Key('accounts_mobile'),
          child: ValueListenableBuilder<Box<Account>>(
            valueListenable: locator.get<Box<Account>>().listenable(),
            builder: (_, value, __) {
              final List<Account> accounts = value.values.toList();
              if (accounts.isEmpty) {
                return EmptyWidget(
                  icon: Icons.credit_card,
                  title: AppLocalizations.of(context)!.errorNoCardsLabel,
                  description: AppLocalizations.of(context)!
                      .errorNoCardsDescriptionLabel,
                );
              }
              accountsBloc.add(AccountSelectedEvent(accounts.first));
              return BlocBuilder(
                bloc: accountsBloc,
                builder: (context, state) {
                  if (state is AccountSelectedState) {
                    return ValueListenableBuilder<Box<Expense>>(
                      valueListenable: locator.get<Box<Expense>>().listenable(),
                      builder: (context, value, child) {
                        final expenses = value.allAccount(state.account.key);
                        expenses.sort((a, b) => b.time.compareTo(a.time));
                        return ScreenTypeLayout(
                          mobile: AccountsMobilePage(
                            accounts: accounts,
                            accountsBloc: accountsBloc,
                            expenses: expenses,
                          ),
                          tablet: AccountsTabletPage(
                            accounts: accounts,
                            accountsBloc: accountsBloc,
                            expenses: expenses,
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
