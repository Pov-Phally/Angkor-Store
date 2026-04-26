import 'package:angkor_store/core/common/widgets/loading_widget.dart';
import 'package:flutter/widgets.dart';

extension WidgetExtention on Widget {
  Widget loading(bool isLoading) {
    return LoadingWidget(originalWidget: this, isLoading: isLoading);
  }
}
