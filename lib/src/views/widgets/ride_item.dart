import 'package:auto_size_text/auto_size_text.dart';
import 'package:driver_app/src/models/status_enum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../app_colors.dart';
import '../../helper/dimensions.dart';
import '../../helper/helper.dart';
import '../../helper/styles.dart';
import '../../models/distance_unit_enum.dart';

import '../../models/ride.dart';
import '../../models/screen_argument.dart';
import '../../repositories/setting_repository.dart';

class RideItemWidget extends StatefulWidget {
  final bool expanded;
  final bool showButtons;
  final Ride ride;
  final Function? loadPedidos;

  RideItemWidget(
      {Key? key,
      this.expanded = false,
      this.showButtons = true,
      this.loadPedidos,
      required this.ride})
      : super(key: key);

  @override
  _RideItemWidgetState createState() => _RideItemWidgetState();
}

class _RideItemWidgetState extends State<RideItemWidget> {
  late bool expanded;

  @override
  void initState() {
    expanded = widget.expanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: !widget.ride.finalized ? 1 : 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(

                margin: EdgeInsets.only(top: 14),
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(2),

                ),
                child: Card(
                  elevation: 0,
                  color: AppColors.lightBlue3,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ExpansionTile(
                    onExpansionChanged: (bool _expanded) {
                      setState(() => expanded = _expanded);
                    },
                    initiallyExpanded: expanded,
                    title: Padding(
                      padding:
                          EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy | HH:mm').format(
                                widget.ride.createdAt ?? DateTime.now()),
                            style: khulaBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: Theme.of(context).primaryColor),
                          ),
                          Expanded(
                            child: Transform.translate(
                              offset: const Offset(25, 0.0),
                              child: AutoSizeText(
                                '${widget.ride.distance.toStringAsFixed(1)}${DistanceUnitEnumHelper.abbreviation(setting.value.distanceUnit, context)} - ${Helper.doubleToString((widget.ride.amount), currency: true)}',
                                textAlign: TextAlign.right,
                                style: khulaBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.requestedBy}: ',
                                style: khulaBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Expanded(
                                child: Transform.translate(
                                  offset: const Offset(25, 0.0),
                                  child: AutoSizeText(
                                    widget.ride.user?.name.padRight(40) ?? '',
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    minFontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    maxFontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    style: khulaBold.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (!expanded)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Transform.translate(
                                  offset: const Offset(40, 0.0),
                                  child: ButtonBar(
                                    buttonPadding: EdgeInsets.zero,
                                    alignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await Navigator.pushNamed(
                                            context,
                                            '/Ride',
                                            arguments: ScreenArgument({
                                              'rideId': widget.ride.id,
                                              'showButtons': widget.showButtons
                                            }),
                                          ).then((value) {
                                            if (widget.loadPedidos != null) {
                                              widget.loadPedidos!();
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .viewCompleteRide,
                                              style: khulaSemiBold.merge(
                                                TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                            Icon(Icons.chevron_right,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    trailing: SizedBox(),
                    children: <Widget>[
                      if (expanded) SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${AppLocalizations.of(context)!.boardingAddress}:',
                              style: khulaBold.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Expanded(
                              child: Text(
                                (widget.ride.boardingLocation?.name ?? '') +
                                    ' - ' +
                                    (widget.ride.boardingLocation?.number ??
                                        ''),
                                textAlign: TextAlign.right,
                                style: khulaRegular.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${AppLocalizations.of(context)!.rideAddress}:',
                              style: khulaBold.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Expanded(
                              child: Text(
                                widget.ride.destinationLocation!.name,
                                textAlign: TextAlign.right,
                                style: khulaRegular.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ButtonBar(
                        buttonPadding: EdgeInsets.zero,
                        alignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/Ride',
                                arguments: ScreenArgument({
                                  'rideId': widget.ride.id,
                                  'showButtons': widget.showButtons
                                }),
                              ).then((value) {
                                if (widget.loadPedidos != null) {
                                  widget.loadPedidos!();
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .viewCompleteRide,
                                  style: khulaSemiBold.merge(
                                    TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                Icon(Icons.chevron_right,
                                    size: 25,
                                    color: Theme.of(context).primaryColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: widget.ride.finalized
                  ? AppColors.mainBlue
                  : Theme.of(context).primaryColor),
          alignment: AlignmentDirectional.center,
          child: Text(
            StatusEnumHelper.description(widget.ride.rideStatus, context),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption!.merge(
                  TextStyle(
                    height: 1,
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
