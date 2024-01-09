part of flutter_mapbox_autocomplete_plus;

class MapBoxAutoCompleteWidget extends StatefulWidget {
  /// Mapbox API_TOKEN
  final String apiKey;

  /// Hint text to show to users
  final String? hint;

  /// Callback on Select of autocomplete result
  final void Function(MapBoxPlace place)? onSelect;

  /// if true will dismiss autocomplete widget once a result has been selected
  final bool closeOnSelect;

  /// The callback that is called when the user taps on the search icon.
  // final void Function(MapBoxPlaces place) onSearch;

  /// Language used for the autocompletion.
  ///
  /// Check the full list of [supported languages](https://docs.mapbox.com/api/search/#language-coverage) for the MapBox API
  final String language;

  /// The point around which you wish to retrieve place information.
  final Location? location;

  /// Limits the no of predections it shows
  final int? limit;

  /// Build context to make ui responsive
  final BuildContext context;

  /// isDark mode
  final bool isDarkMode;

  ///Limits the search to the given country
  ///
  /// Check the full list of [supported countries](https://docs.mapbox.com/api/search/) for the MapBox API
  final String? country;

  MapBoxAutoCompleteWidget({
    required this.apiKey,
    required this.context,
    required this.isDarkMode,
    this.hint,
    this.onSelect,
    this.closeOnSelect = true,
    this.language = "en",
    this.location,
    this.limit,
    this.country,
  });

  @override
  _MapBoxAutoCompleteWidgetState createState() =>
      _MapBoxAutoCompleteWidgetState();
}

class _MapBoxAutoCompleteWidgetState extends State<MapBoxAutoCompleteWidget> {
  final _searchFieldTextController = TextEditingController();
  final _searchFieldTextFocus = FocusNode();

  Predections? _placePredictions = Predections.empty();

  Future<void> _getPlaces(String input) async {
    if (input.length > 0) {
      String url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?access_token=${widget.apiKey}&cachebuster=1566806258853&autocomplete=true&language=${widget.language}&limit=${widget.limit}";
      if (widget.location != null) {
        url += "&proximity=${widget.location!.lng}%2C${widget.location!.lat}";
      }
      if (widget.country != null) {
        url += "&country=${widget.country}";
      }
      final response = await http.get(Uri.parse(url));
      // print(response.body);
      // // final json = jsonDecode(response.body);
      final predictions = Predections.fromRawJson(response.body);

      _placePredictions = null;

      setState(() {
        _placePredictions = predictions;
      });
    } else {
      setState(() => _placePredictions = Predections.empty());
    }
  }

  void _selectPlace(MapBoxPlace prediction) async {
    // Calls the `onSelected` callback
    widget.onSelect!(prediction);
    if (widget.closeOnSelect) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 56.v,
          leadingWidth: 70.h,
          leading: widget.isDarkMode
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                )
              : InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                  ),
                )),
      body: Container(
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.5, 0),
            end: Alignment(0.5, 1),
            colors: [
              widget.isDarkMode ? Color(0XFF11002D) : Color(0xfff1fcff),
              widget.isDarkMode ? Color(0XFF00000D) : Color(0xfffffdf3),
            ],
          ),
        ),
        child: Stack(
          children: [
            if (!widget.isDarkMode)
              Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                            width: 591,
                            height: 591,
                            decoration: BoxDecoration(
                                gradient: RadialGradient(
                                    radius: 1,
                                    center: Alignment(0.4, 0.3),
                                    colors: [
                                  Color(0xffFFF7CA),
                                  Color(0xffffffff),
                                ]))),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                            width: 591,
                            height: 591,
                            decoration: BoxDecoration(
                                gradient: RadialGradient(
                                    radius: 1,
                                    center: Alignment(-1, -0.5),
                                    colors: [
                                  Color(0xff97ECFF),
                                  Color(0xffFFFFFF).withOpacity(0.4),
                                ]))),
                      ),
                    ),
                  ),
                ],
              ),
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 15.h, right: 15.h, top: 90.v),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    child: OutlineGradientButton(
                      padding: EdgeInsets.only(
                        left: 2.h,
                        top: 2.v,
                        right: 2.h,
                        bottom: 2.v,
                      ),
                      strokeWidth: 2.h,
                      gradient: LinearGradient(
                        begin: Alignment(0.09, 1),
                        end: Alignment(0.94, 1),
                        colors: [
                          Color(0XFFC53E8D),
                          Color(0XFF8A52F3),
                        ],
                      ),
                      corners: Corners(
                        topLeft: Radius.circular(30.adaptSize),
                        topRight: Radius.circular(30.adaptSize),
                        bottomLeft: Radius.circular(30.adaptSize),
                        bottomRight: Radius.circular(30.adaptSize),
                      ),
                      child: CustomTextFormField(
                        controller: _searchFieldTextController,
                        hintText: widget.hint,
                        textStyle: widget.isDarkMode
                            ? TextStyle(
                                color: Colors.white,
                                fontSize: 18.fSize,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              )
                            : TextStyle(
                                color: Color(0XFF33196B),
                                fontSize: 18.fSize,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              ),
                        hintStyle: widget.isDarkMode
                            ? TextStyle(
                                color: Colors.white.withOpacity(0.67),
                                fontSize: 18.fSize,
                                fontWeight: FontWeight.w500,
                              )
                            : TextStyle(
                                color: Color(0XFF33196B),
                                fontSize: 18.fSize,
                                fontWeight: FontWeight.w500,
                              ),
                        textInputType: TextInputType.text,
                        autofocus: true,
                        focusNode: _searchFieldTextFocus,
                        onChanged: (input) => _getPlaces(input),
                        onFieldSubmitted: (value) =>
                            _searchFieldTextFocus.unfocus(),
                        suffix: Container(
                          margin: EdgeInsets.only(
                              left: 30.h, top: 19.v, right: 29.h, bottom: 19.v),
                          child: GestureDetector(
                            onTap: () => _searchFieldTextController.clear(),
                            child: Icon(
                              Icons.clear,
                              size: 30.adaptSize,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        suffixConstraints: BoxConstraints(
                          maxHeight: 60.v,
                        ),
                        borderDecoration: TextFormFieldStyleHelper.outlineTL301,
                        fillColor: widget.isDarkMode
                            ? Color(0XFF02000B)
                            : Color(0XFFFFFFFF),
                      ),
                    ),
                  ),
                  ListView.separated(
                    separatorBuilder: (cx, _) => Divider(),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _placePredictions!.features!.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      MapBoxPlace _singlePlace =
                          _placePredictions!.features![i];
                      return ListTile(
                        title: Text(
                          _singlePlace.text!,
                          style: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        subtitle: Text(_singlePlace.placeName!,
                            style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black)),
                        onTap: () => _selectPlace(_singlePlace),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
