import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../app/routes.dart';
import '../../../core/common.dart';
import '../bloc/home_bloc.dart';
import '../widgets/content_widget.dart';
import '../widgets/desktop_drawer_item_widget.dart';

class HomeDesktopWidget extends StatelessWidget {
  const HomeDesktopWidget({
    super.key,
    required this.homeBloc,
    required this.dateTimeRangeNotifier,
    required this.floatingActionButton,
  });
  final HomeBloc homeBloc;
  final Widget floatingActionButton;
  final ValueNotifier<DateTimeRange?> dateTimeRangeNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          BlocBuilder(
            bloc: homeBloc,
            builder: (context, state) {
              if (state is CurrentIndexState) {
                return Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: kToolbarHeight),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.appTitle,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      NavigationBarItem(
                        title: AppLocalizations.of(context)!.homeLabel,
                        icon: MdiIcons.home,
                        isSelected: state.currentPage == PageType.home,
                        onPressed: () => homeBloc
                            .add(const CurrentIndexEvent(PageType.home)),
                      ),
                      NavigationBarItem(
                        title: AppLocalizations.of(context)!.accountsLabel,
                        icon: MdiIcons.creditCard,
                        isSelected: state.currentPage == PageType.accounts,
                        onPressed: () => homeBloc
                            .add(const CurrentIndexEvent(PageType.accounts)),
                      ),
                      NavigationBarItem(
                        title: AppLocalizations.of(context)!.categoryLabel,
                        icon: Icons.category,
                        isSelected: state.currentPage == PageType.category,
                        onPressed: () => homeBloc
                            .add(const CurrentIndexEvent(PageType.category)),
                      ),
                      NavigationBarItem(
                        title: AppLocalizations.of(context)!.budgetLabel,
                        icon: MdiIcons.wallet,
                        isSelected:
                            state.currentPage == PageType.budgetOverview,
                        onPressed: () => homeBloc.add(
                            const CurrentIndexEvent(PageType.budgetOverview)),
                      ),
                      NavigationBarItem(
                        title: AppLocalizations.of(context)!.debtsLabel,
                        icon: MdiIcons.accountCash,
                        isSelected: state.currentPage == PageType.debts,
                        onPressed: () => homeBloc
                            .add(const CurrentIndexEvent(PageType.debts)),
                      ),
                      const Divider(),
                      NavigationBarItem(
                        title: AppLocalizations.of(context)!.settingsLabel,
                        icon: MdiIcons.cog,
                        isSelected: false,
                        onPressed: () =>
                            GoRouter.of(context).pushNamed(settingsPath),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const VerticalDivider(),
          Expanded(
            child: Material(
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              child: ContentWidget(
                dateTimeRangeNotifier: dateTimeRangeNotifier,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
