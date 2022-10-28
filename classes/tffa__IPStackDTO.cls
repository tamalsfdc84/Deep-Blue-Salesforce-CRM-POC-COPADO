/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IPStackDTO {
    global String city {
        get;
        set;
    }
    global tffa.IPStackDTO.Connection connection {
        get;
        set;
    }
    global String continentCode {
        get;
        set;
    }
    global String continentName {
        get;
        set;
    }
    global String countryCode {
        get;
        set;
    }
    global String countryName {
        get;
        set;
    }
    global tffa.IPStackDTO.CurrencyX currencyX {
        get;
        set;
    }
    global tffa.IPStackDTO.Error error {
        get;
        set;
    }
    global String ip {
        get;
        set;
    }
    global Double latitude {
        get;
        set;
    }
    global tffa.IPStackDTO.Location location {
        get;
        set;
    }
    global Double longitude {
        get;
        set;
    }
    global String regionCode {
        get;
        set;
    }
    global String regionName {
        get;
        set;
    }
    global tffa.IPStackDTO.Security security {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global tffa.IPStackDTO.Timezone timeZone {
        get;
        set;
    }
    global String typeX {
        get;
        set;
    }
    global String zip {
        get;
        set;
    }
    global IPStackDTO() {

    }
    global static tffa.IPStackDTO deserialize(String jsonString) {
        return null;
    }
    global override String toString() {
        return null;
    }
global class Connection {
    global Integer asn {
        get;
        set;
    }
    global String isp {
        get;
        set;
    }
    global Connection() {

    }
}
global class CurrencyX {
    global String code {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String plural {
        get;
        set;
    }
    global String symbol {
        get;
        set;
    }
    global String symbolNative {
        get;
        set;
    }
    global CurrencyX() {

    }
}
global class Error {
    global String code {
        get;
        set;
    }
    global String info {
        get;
        set;
    }
    global String typeX {
        get;
        set;
    }
    global Error() {

    }
}
global class Languages {
    global String code {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String native {
        get;
        set;
    }
    global Languages() {

    }
}
global class Location {
    global String callingCode {
        get;
        set;
    }
    global String capital {
        get;
        set;
    }
    global String countryFlag {
        get;
        set;
    }
    global String countryFlagEmoji {
        get;
        set;
    }
    global String countryFlagEmojiUnicode {
        get;
        set;
    }
    global Integer geonameId {
        get;
        set;
    }
    global Boolean isEU {
        get;
        set;
    }
    global List<tffa.IPStackDTO.Languages> languages {
        get;
        set;
    }
    global Location() {

    }
}
global class Security {
    global String crawlerName {
        get;
        set;
    }
    global String crawlerType {
        get;
        set;
    }
    global Boolean isCrawler {
        get;
        set;
    }
    global Boolean isProxy {
        get;
        set;
    }
    global Boolean isTor {
        get;
        set;
    }
    global String proxyType {
        get;
        set;
    }
    global String threatLevel {
        get;
        set;
    }
    global List<String> threatTypes {
        get;
        set;
    }
    global Security() {

    }
}
global class Timezone {
    global String code {
        get;
        set;
    }
    global String currentTime {
        get;
        set;
    }
    global Integer gmtOffset {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global Boolean isDaylightSaving {
        get;
        set;
    }
    global Timezone() {

    }
}
}
