// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';

class PickerDialogStyle {
	final Color? backgroundColor;

	final TextStyle? countryCodeStyle;

	final TextStyle? countryNameStyle;

	final Widget? listTileDivider;

	final EdgeInsets? listTilePadding;

	final EdgeInsets? padding;

	final Color? searchFieldCursorColor;

	final InputDecoration? searchFieldInputDecoration;

	final EdgeInsets? searchFieldPadding;

	final double? width;

	PickerDialogStyle({
		this.backgroundColor,
		this.countryCodeStyle,
		this.countryNameStyle,
		this.listTileDivider,
		this.listTilePadding,
		this.padding,
		this.searchFieldCursorColor,
		this.searchFieldInputDecoration,
		this.searchFieldPadding,
		this.width,
	});
}

class CountryPickerDialog extends StatefulWidget {
	final List<Country> countryList;
	final Country selectedCountry;
	final ValueChanged<Country> onCountryChanged;
	final String searchText;
	final List<Country> filteredCountries;
	final PickerDialogStyle? style;
	final String languageCode;

	const CountryPickerDialog({
		Key? key,
		required this.searchText,
		required this.languageCode,
		required this.countryList,
		required this.onCountryChanged,
		required this.selectedCountry,
		required this.filteredCountries,
		this.style,
	}) : super(key: key);

	@override
	State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
	late List<Country> _filteredCountries;
	late Country _selectedCountry;

	@override
	void initState() {
		_selectedCountry = widget.selectedCountry;
		_filteredCountries = widget.filteredCountries.toList()..sort((a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: widget.style?.padding ?? const EdgeInsets.all(10),
			margin: const EdgeInsets.fromLTRB(10,10,10,0),
			child: Column(
				children: <Widget>[
					PhoneTextField(
						name: widget.searchText,
						languageCode: widget.languageCode,
						prefixIcon: 0xf002,
						paddingContent: const EdgeInsets.fromLTRB(15,10,0,5.5),
						inputBG: const Color(0xfff1f1f1),
						onChange: (value){
							_filteredCountries = widget.countryList.stringSearch(value)..sort((a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)));
							if (mounted) setState(() {});
						},
					),
					const SizedBox(height: 20),
					Expanded(
						child: ListView.builder(
							shrinkWrap: true,
							itemCount: _filteredCountries.length,
							itemBuilder: (ctx, index) => Column(
								children: <Widget>[
									GestureDetector(
										behavior: HitTestBehavior.translucent,
										onTap: () {
											_selectedCountry = _filteredCountries[index];
											widget.onCountryChanged(_selectedCountry);
											Navigator.of(context).pop();
										},
										child: Container(
											width: MediaQuery.of(context).size.width,
											padding: widget.style?.listTilePadding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
											child: Row(
												children: [
													kIsWeb ? Image.asset(
														'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
														package: 'intl_phone_field',
														width: 32,
													) : Text(
														_filteredCountries[index].flag,
														style: const TextStyle(fontSize: 19),
													),
													Container(
														margin: const EdgeInsets.only(left: 10),
														child: Text(
															_filteredCountries[index].localizedName(widget.languageCode),
															style: widget.style?.countryNameStyle ?? const TextStyle(),
														),
													),
													const Spacer(),
													Text(
														'+${_filteredCountries[index].dialCode}',
														style: widget.style?.countryCodeStyle ?? const TextStyle(fontWeight: FontWeight.w500),
													),
												],
											),
										),
									),
									widget.style?.listTileDivider ?? const Divider(thickness: 1),
								],
							),
						),
					),
				],
			),
		);
	}
}

class PhoneTextField extends StatefulWidget {
    const PhoneTextField({Key? key, 
        this.onChange,
        this.onSuffixChange,
        this.name='',
        this.showData='',
        this.keyboard,
        this.password=false,
        this.enabled=true,
        this.textAlign=TextAlign.start,
        this.enabledBorder='false',
        this.prefixIcon,
        this.suffixIcon,
        this.inputBG,
        this.fontColor,
        this.maxLength=100000000000000000,
        this.height=45,
        this.maxLines=1,
        this.focusNode,
        this.borderRadius,
        this.fontWeight = FontWeight.w300,
		this.paddingContent,
		this.min,
		this.max,
		this.languageCode = 'en',
    }) : super(key: key);

	final Function? onChange;
	final Function? onSuffixChange;
	final String name;
	final String showData;
	final String? keyboard;
	final bool password;
	final bool enabled;
	final TextAlign textAlign;
	final String enabledBorder;
	final int? prefixIcon;
	final int? suffixIcon;
	final Color? inputBG;
	final Color? fontColor;
	final int maxLength;
	final double height;
	final int maxLines;
    final FocusNode? focusNode;
    final BorderRadius? borderRadius;
    final FontWeight fontWeight;
	final EdgeInsets? paddingContent;
	final double? min;
	final double? max;
	final String languageCode;

    @override
    State<PhoneTextField> createState() => _PhoneTextFieldState();
}
class _PhoneTextFieldState extends State<PhoneTextField> {
    late EdgeInsets paddingContent;
    bool showPassword = false;
    initial(){
        setState(() {
			var currentLang = widget.languageCode;
            showPassword = widget.password;
            
            if(currentLang == 'zh'){
                paddingContent = const EdgeInsets.fromLTRB(15,0,0,5.5);
            }else{
                paddingContent = const EdgeInsets.fromLTRB(15,0,13,5.5);
            }
            
            if(widget.prefixIcon!=null && (widget.suffixIcon!=null || widget.password)){
                if(currentLang == 'zh'){
                    paddingContent = const EdgeInsets.fromLTRB(15,10,0,0);
                }else{
                    paddingContent = const EdgeInsets.fromLTRB(15,12,13,0);
                }
            }else if(widget.prefixIcon!=null){
                if(currentLang == 'zh'){
                    paddingContent = const EdgeInsets.fromLTRB(0,10,0,0);
                }else{
                    paddingContent = const EdgeInsets.fromLTRB(0,12,0,0);
                }
            }else if(widget.suffixIcon!=null || widget.password){
                if(currentLang == 'zh'){
                    paddingContent = const EdgeInsets.fromLTRB(15,10,0,0);
                }else{
                    paddingContent = const EdgeInsets.fromLTRB(15,12,13,0);
                }
            }
        });
    }

    @override
    void initState() {
        super.initState();
        initial();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: widget.inputBG??const Color.fromRGBO(000,000,000,.5),
                borderRadius: widget.borderRadius??BorderRadius.circular(5)
            ),
            child:Container(
                key: widget.key,
                height: widget.height,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: (widget.enabledBorder == 'true')?const Color(0xffc6c6c6):Colors.transparent,
                            width: 0.5
                        )
                    )
                ),
                child: TextFormField(
                    focusNode: widget.focusNode,
                    enabled: widget.enabled,
                    cursorColor: widget.fontColor??const Color(0xff222834),
                    cursorWidth: 1.5,
                    textAlign: widget.textAlign,
                    initialValue: widget.showData,
                    textInputAction: TextInputAction.go,
                    keyboardType: (widget.keyboard == 'digits' || widget.keyboard == 'digitsOnly' || widget.keyboard == 'intOnly' || widget.keyboard == 'minMaxOnly')?const TextInputType.numberWithOptions(decimal: true):TextInputType.text,
                    inputFormatters: 
                    (widget.keyboard == 'intOnly')?[FilteringTextInputFormatter.digitsOnly]:
                    (widget.keyboard == 'digitsOnly')?[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))]:[],
                    obscureText: showPassword,
                    maxLength: widget.maxLength,
                    maxLines: widget.maxLines,
                    style: TextStyle(
                        fontSize: 14,
                        color: widget.fontColor??const Color(0xff222834),
                        fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                        contentPadding: widget.paddingContent ?? paddingContent,
                        counterText:'',
                        prefixIcon: (widget.prefixIcon==null)?null:
                        Container(
                            alignment: Alignment.center,
                            width: 20,
                            margin: const EdgeInsets.only(left: 2.5),
                            child: FaIcon(
                                IconDataLight(widget.prefixIcon!),
                                color: const Color(0xff222834),
                                size: 15,
                            ),
                        ),
                        prefixIconConstraints: BoxConstraints(
                            maxWidth: (widget.prefixIcon==null)?0:38,
                            minWidth: (widget.prefixIcon==null)?0:38
                        ),
                        suffixIcon: (widget.password)?
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async{
                                setState(() {
                                    showPassword = !showPassword;
                                });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: 20,
                                margin: const EdgeInsets.only(left: 2.5),
                                child: FaIcon(
                                    IconDataLight((showPassword)?0xf070:0xf06e),
                                    color: const Color(0xff222834),
                                    size: 15,
                                ),
                            ),
                        ):(widget.suffixIcon==null)?null:
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async{
                                if(widget.onSuffixChange!=null){
                                    widget.onSuffixChange!();
                                }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: 20,
                                margin: const EdgeInsets.only(left: 2.5),
                                child: FaIcon(
                                    IconDataLight(widget.suffixIcon!),
                                    color: const Color(0xff222834),
                                    size: 15,
                                ),
                            ),
                        ),
                        suffixIconConstraints: BoxConstraints(
                            maxWidth: (widget.suffixIcon!=null || widget.password)?42:0,
                            minWidth: (widget.suffixIcon!=null || widget.password)?42:0
                        ),
                        hintText: widget.name,
                        hintStyle: const TextStyle(
                            color: Color(0xff9298a4),
                            fontSize: 13,
                            fontWeight: FontWeight.w400
                        ),
                        enabledBorder:const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent
                            )
                        ),
                        focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent
                            )
                        ),
                        disabledBorder:const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent
                            )
                        ),
                    ),
                    onChanged: (value) {
                        if(widget.onChange!=null){
                            widget.onChange!(value);
                        }
                    },
                )
            )
        );
    }
}
