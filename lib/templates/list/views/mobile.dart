import 'package:flutter/material.dart';
import '../../../not_connection_widget.dart';

import '../../../responsive_scaffold.dart';
import '../responsive_list.dart';

class MobileView extends StatelessWidget {
  MobileView(
      {Key? key,
      required this.slivers,
      required this.detailBuilder,
      required List<Widget> children,
      required this.detailScaffoldKey,
      required this.useRootNavigator,
      required this.navigator,
      required this.nullItems,
      required this.emptyItems,
      required this.scrollController,
      required this.haveConnection,
      required this.text,
      required this.registros,
      this.textTopOfList,
      this.switchFilter1})
      : childDelagate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          addSemanticIndexes: false,
        ),
        super(key: key);

  MobileView.builder(
      {Key? key,
      required this.slivers,
      required this.detailBuilder,
      required int itemCount,
      required IndexedWidgetBuilder itemBuilder,
      required this.detailScaffoldKey,
      required this.useRootNavigator,
      required this.navigator,
      required this.nullItems,
      required this.emptyItems,
      required this.scrollController,
      required this.haveConnection,
      required this.text,
      required this.registros,
      this.textTopOfList,
      this.switchFilter1})
      : childDelagate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          addSemanticIndexes: false,
        ),
        super(key: key);

  const MobileView.custom(
      {Key? key,
      required this.slivers,
      required this.detailBuilder,
      required this.childDelagate,
      required this.detailScaffoldKey,
      required this.useRootNavigator,
      required this.navigator,
      required this.nullItems,
      required this.emptyItems,
      required this.scrollController,
      required this.haveConnection,
      required this.text,
      required this.registros,
      this.textTopOfList,
      this.switchFilter1})
      : super(key: key);

  final List<Widget>? slivers;
  final DetailWidgetBuilder detailBuilder;
  final Key? detailScaffoldKey;
  final bool useRootNavigator;
  final NavigatorState? navigator;
  final Widget? nullItems, emptyItems;
  final SliverChildDelegate childDelagate;
  final ScrollController scrollController;
  final bool haveConnection;
  final String text;
  final int? registros;
  final String? textTopOfList;
  final Widget? switchFilter1;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      if (!haveConnection) NotConnectionWidget(text: text),
      // if (registros != null || textTopOfList != null)
      //   Row(
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       mainAxisAlignment: (textTopOfList != null)
      //           ? MainAxisAlignment.spaceBetween
      //           : MainAxisAlignment.end,
      //       children: [
      //         if (textTopOfList != null)
      //           Container(
      //             padding: const EdgeInsets.all(8),
      //             child: Text('$textTopOfList',
      //                 style: const TextStyle(color: Colors.grey, fontSize: 12)),
      //           ),
      //         Container(
      //           padding: const EdgeInsets.all(8),
      //           child: Text('$registros Items',
      //               style: const TextStyle(color: Colors.grey, fontSize: 12)),
      //         ),
      //       ]),
      if (registros != null || switchFilter1 != null)
        Row(
            mainAxisAlignment: (switchFilter1 != null)
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (switchFilter1 != null) Flexible(child: switchFilter1!),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text('$registros Items',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ]),
      Expanded(
          child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          ...?slivers,
          Builder(
            builder: (BuildContext context) {
              if (childDelagate.estimatedChildCount == null &&
                  nullItems != null) {
                return SliverFillRemaining(child: nullItems);
              }
              if (childDelagate.estimatedChildCount != null &&
                  childDelagate.estimatedChildCount == 0 &&
                  emptyItems != null) {
                return SliverFillRemaining(child: emptyItems);
              }
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return KeepAlive(
                    keepAlive: true,
                    child: IndexedSemantics(
                      index: index,
                      child: GestureDetector(
                        onTap: () {
                          (navigator ?? Navigator.of(context))
                              .push(MaterialPageRoute(builder: (context) {
                            final _details =
                                detailBuilder(context, index, false);
                            return DetailView(
                                detailScaffoldKey: detailScaffoldKey,
                                itemCount: childDelagate.estimatedChildCount,
                                details: _details);
                          }));
                        },
                        child: Container(
                          child: childDelagate.build(context, index),
                        ),
                      ),
                    ),
                  );
                },
                childCount: childDelagate.estimatedChildCount ?? 0,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                addSemanticIndexes: false,
              ));
            },
          )
        ],
      ))
    ]);
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    required this.itemCount,
    required DetailsScreen details,
    required this.detailScaffoldKey,
  })  : _details = details,
        super(key: key);

  final int? itemCount;
  final DetailsScreen _details;
  final Key? detailScaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: detailScaffoldKey,
      appBar: _details.appBar,
      body: _details.body,
    );
  }
}
