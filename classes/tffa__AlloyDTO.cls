/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AlloyDTO {
    global AlloyDTO() {

    }
global class AdditionalDataPrompts extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.QuestionSet answers;
    global AdditionalDataPrompts() {

    }
}
global class Address extends tffa.AlloyDTO.BaseDTO {
    global String city;
    global String country_code;
    global String formatted {
        get;
    }
    global String line_1;
    global String line_2;
    global Integer months_at_address;
    global String postal_code;
    global String state;
    global String type;
    global Integer years_at_address;
    global Address() {

    }
}
global class AgentDetail extends tffa.AlloyDTO.BaseDTO {
    global String email;
    global String external_id;
    global AgentDetail() {

    }
    global AgentDetail(String email, String external_id) {

    }
}
global class Answer extends tffa.AlloyDTO.BaseDTO {
    global Long answer_id;
    global Long question_id;
    global Answer() {

    }
    global Answer(Long questionId, Long answerId) {

    }
}
global class AnswerChoice extends tffa.AlloyDTO.BaseDTO {
    global String answer;
    global Long id;
    global AnswerChoice() {

    }
}
global abstract class BaseDTO extends tffa.AbstractDTO {
    global BaseDTO() {

    }
    global virtual tffa.AlloyDTO.BaseDTO deserialize(String jsonString) {
        return null;
    }
    global virtual List<tffa.AlloyDTO.BaseDTO> deserializeAsList(String jsonString) {
        return null;
    }
    global virtual Object get(String key) {
        return null;
    }
    global virtual Object get(String key, System.Type apexType) {
        return null;
    }
    global Map<String,Object> getMap() {
        return null;
    }
    global virtual tffa.AlloyDTO.RawStruct getRawStruct(String key) {
        return null;
    }
    global virtual List<tffa.AlloyDTO.RawStruct> getRawStructs(String key) {
        return null;
    }
    global virtual String getString(String key) {
        return null;
    }
    global virtual void put(String key, Object value) {

    }
    global virtual String serialize() {
        return null;
    }
}
global class CreditRiskAssessment extends tffa.AlloyDTO.BaseDTO {
    global Map<String,tffa.AlloyDTO.CreditRiskModel> models;
    global String source;
    global CreditRiskAssessment() {

    }
}
global class CreditRiskModel extends tffa.AlloyDTO.BaseDTO {
    global String bureau;
    global List<String> codes;
    global List<tffa.AlloyDTO.CreditRiskModelCode> model_codes;
    global String name;
    global Decimal score;
    global CreditRiskModel() {

    }
}
global class CreditRiskModelCode extends tffa.AlloyDTO.BaseDTO {
    global String code;
    global String description;
    global CreditRiskModelCode() {

    }
}
global class DataMatchResult extends tffa.AlloyDTO.BaseDTO {
    global List<String> matched;
    global Decimal score;
    global List<String> unmatched;
    global DataMatchResult() {

    }
}
global class DataMatchResults extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.DataMatchResult address;
    global Decimal average_score;
    global tffa.AlloyDTO.DataMatchResult business_address;
    global tffa.AlloyDTO.DataMatchResult business_fein;
    global tffa.AlloyDTO.DataMatchResult business_name;
    global tffa.AlloyDTO.DataMatchResult business_owner;
    global tffa.AlloyDTO.DataMatchResult business_phone;
    global tffa.AlloyDTO.DataMatchResult dob;
    global tffa.AlloyDTO.DataMatchResult email;
    global tffa.AlloyDTO.DataMatchResult ip_address;
    global tffa.AlloyDTO.DataMatchResult name;
    global tffa.AlloyDTO.DataMatchResult phone;
    global tffa.AlloyDTO.DataMatchResult representative_relationship;
    global tffa.AlloyDTO.DataMatchResult ssn;
    global DataMatchResults() {

    }
}
global class Document extends tffa.AlloyDTO.BaseDTO {
    global String approval_agent_email;
    global Long approval_timestamp;
    global Boolean approved;
    global Blob body;
    global String document_token;
    global String entity_token;
    global String extension;
    global String name;
    global String note;
    global String note_author_agent_email;
    global List<tffa.AlloyDTO.Note> notes;
    global Long timestamp;
    global String type;
    global Boolean uploaded;
    global Document() {

    }
}
global class DueDiligenceResult extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.FinancialRiskAssessment financial;
    global tffa.AlloyDTO.FraudCheckResults fraud;
    global List<tffa.AlloyDTO.IDAResult> identity_questions;
    global tffa.AlloyDTO.WatchlistMatchResults watchlists;
    global DueDiligenceResult() {

    }
}
global class Entity extends tffa.AlloyDTO.BaseDTO {
    global Boolean archived;
    global Long created;
    global String entity_token;
    global List<tffa.AlloyDTO.EntityEvaluation> evaluations;
    global String external_entity_id;
    global tffa.AlloyDTO.Metadata meta;
    global String name;
    global List<tffa.AlloyDTO.EntityReview> reviews;
    global String type;
    global Entity() {

    }
    global tffa.AlloyDTO.EntityReview getReview(String reviewToken) {
        return null;
    }
}
global class EntityEvaluation extends tffa.AlloyDTO.BaseDTO {
    global String application_name;
    global String evaluation_token;
    global String outcome;
    global String status;
    global Long timestamp;
    global EntityEvaluation() {

    }
}
global class EntityReview extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.AgentDetail agent;
    global String application_name;
    global String application_token;
    global Long completed;
    global String entity_token;
    global String external_entity_id;
    global String external_group_id;
    global String group_token;
    global List<tffa.AlloyDTO.Note> notes;
    global String outcome;
    global String reason;
    global List<String> reasons;
    global String review_token;
    global String reviewer;
    global Long started;
    global Long timestamp;
    global EntityReview() {

    }
    global void addReason(String reason) {

    }
}
global class Error extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.ErrorDetails details;
    global String error_token;
    global String message;
    global Integer minor_code;
    global String type;
    global Error() {

    }
}
global class ErrorDetails extends tffa.AlloyDTO.BaseDTO {
    global String message;
    global String path;
    global String type;
    global ErrorDetails() {

    }
}
global class ErrorResponse extends tffa.AlloyDTO.BaseDTO {
    global String application_token;
    global Integer application_version_id;
    global String entity_token;
    global tffa.AlloyDTO.Error error;
    global String evaluation_token;
    global Integer status_code;
    global Long timestamp;
    global ErrorResponse() {

    }
}
global class EvaluationRequest extends tffa.AlloyDTO.BaseDTO {
    global String address_city;
    global String address_complete;
    global String address_country_code;
    global String address_line_1;
    global String address_line_2;
    global String address_postal_code;
    global String address_state;
    global String address_type;
    global List<tffa.AlloyDTO.Address> addresses;
    global List<tffa.AlloyDTO.Answer> answers;
    global Boolean authenticated;
    global Date birth_date;
    global String business_address_city;
    global String business_address_country_code;
    global String business_address_line_1;
    global String business_address_line_2;
    global String business_address_postal_code;
    global String business_address_state;
    global String business_address_type;
    global String business_federal_ein;
    global String business_id;
    global String business_name;
    global String business_phone_number;
    global String business_type;
    global String business_website;
    global String channel;
    global String comment;
    global String document_id_card;
    global String document_id_card_nationality;
    global String document_license;
    global Date document_license_expiry_date;
    global Date document_license_issue_date;
    global String document_license_postal_code;
    global String document_license_state;
    global String document_national_id;
    global String document_passport;
    global Date document_passport_expiry_date;
    global Date document_passport_issue_date;
    global String document_passport_nationality;
    global String document_passport_short_number;
    global String document_ssn;
    global String document_ssn_first5;
    global String document_ssn_last4;
    global String document_tax_id;
    global String document_token_back;
    global String document_token_front;
    global String email_address;
    global String employer_name;
    global String entity_purpose;
    global String entity_token;
    global String entity_type;
    global String evaluation_token;
    global Boolean existing_customer;
    global String external_entity_id;
    global String external_group_id;
    global String formatted_address {
        get;
    }
    global String full_name {
        get;
    }
    global String gender;
    global String iovation_blackbox;
    global String ip_address_v4;
    global String ip_address_v6;
    global Decimal latitude;
    global Boolean lending_product;
    global Decimal longitude;
    global tffa.AlloyDTO.Metadata meta;
    global String name_first;
    global String name_last;
    global String name_middle;
    global String name_prefix;
    global String name_suffix;
    global String occupation_type;
    global String phone_number;
    global List<String> product_category;
    global List<tffa.AlloyDTO.Representative> representatives;
    global String social_facebook;
    global String social_twitter;
    global String socure_session_id;
    global Boolean surescore;
    global EvaluationRequest() {

    }
    global tffa.AlloyDTO.Address addAddress() {
        return null;
    }
    global void addAnswer(Long questionId, Long answerId) {

    }
    global tffa.AlloyDTO.Representative addRepresentative() {
        return null;
    }
}
global class EvaluationResponse extends tffa.AlloyDTO.BaseDTO {
    global String application_token;
    global Integer application_version_id;
    global tffa.AlloyDTO.DueDiligenceResult diligence;
    global String entity_token;
    global tffa.AlloyDTO.Error error;
    global String evaluation_status;
    global String evaluation_token;
    global String external_entity_id;
    global String external_group_id;
    global tffa.AlloyDTO.EvaluationRequest formatted;
    global Map<String,tffa.AlloyDTO.FormattedResponse> formatted_responses;
    global String group_token;
    global tffa.AlloyDTO.DataMatchResults matching;
    global tffa.AlloyDTO.Metadata meta;
    global List<tffa.AlloyDTO.Parameter> optional;
    global String parent_entity_token;
    global tffa.AlloyDTO.AdditionalDataPrompts prompts;
    global tffa.AlloyDTO.RelatedData related_data;
    global List<tffa.AlloyDTO.Parameter> required;
    global Integer status_code;
    global tffa.AlloyDTO.EvaluationSummary summary;
    global tffa.AlloyDTO.EvaluationRequest supplied;
    global Long timestamp;
    global List<String> webhook_pending_services;
    global EvaluationResponse() {

    }
    global tffa.AlloyDTO.FormattedResponse getFormattedResponse(String service) {
        return null;
    }
    global tffa.AlloyDTO.RawResponse getRawResponse(String service) {
        return null;
    }
}
global class EvaluationSummary extends tffa.AlloyDTO.BaseDTO {
    global String outcome;
    global List<String> outcome_reasons;
    global String result;
    global Decimal score;
    global Map<String,String> services;
    global List<String> tags;
    global EvaluationSummary() {

    }
    global Boolean hasFailed(String service) {
        return null;
    }
    global Boolean hasRun(String service) {
        return null;
    }
    global Boolean hasTag(String tag) {
        return null;
    }
}
global class FinancialRiskAssessment extends tffa.AlloyDTO.BaseDTO {
    global List<tffa.AlloyDTO.CreditRiskAssessment> credit;
    global FinancialRiskAssessment() {

    }
}
global class FormattedResponse extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.SourceData data;
    global tffa.AlloyDTO.SourceDataMatchResults matching;
    global FormattedResponse() {

    }
}
global class FraudCheckResult extends tffa.AlloyDTO.BaseDTO {
    global String attribute;
    global Decimal normalized_score;
    global Decimal raw_score;
    global FraudCheckResult() {

    }
}
global class FraudCheckResults extends tffa.AlloyDTO.BaseDTO {
    global Decimal average_score;
    global Decimal score;
    global Map<String,tffa.AlloyDTO.FraudCheckResult> sources;
    global FraudCheckResults() {

    }
}
global class IDAResult extends tffa.AlloyDTO.BaseDTO {
    global Decimal score;
    global String source;
    global IDAResult() {

    }
}
global class Metadata extends tffa.AlloyDTO.BaseDTO {
    global String applicant_role;
    global String submission_id;
    global String webhook_url;
    global Metadata() {

    }
}
global class Note extends tffa.AlloyDTO.BaseDTO {
    global Long created_at;
    global String document_token;
    global String entity_token;
    global String external_entity_id;
    global String note;
    global String note_author_agent_email;
    global String review_token;
    global Long updated_at;
    global Note() {

    }
    global Note(String note, String authorAgentEmail) {

    }
}
global class Parameter extends tffa.AlloyDTO.BaseDTO {
    global String description;
    global String key;
    global String message;
    global String regex;
    global String type;
    global Parameter() {

    }
}
global class Question extends tffa.AlloyDTO.BaseDTO {
    global List<tffa.AlloyDTO.AnswerChoice> answers;
    global Long id;
    global String question;
    global Question() {

    }
}
global class QuestionSet extends tffa.AlloyDTO.BaseDTO {
    global List<tffa.AlloyDTO.Question> questions;
    global QuestionSet() {

    }
}
global class RawResponse extends tffa.AlloyDTO.BaseDTO {
}
global class RawStruct extends tffa.AlloyDTO.BaseDTO {
}
global class RelatedData extends tffa.AlloyDTO.BaseDTO {
    global List<tffa.AlloyDTO.SocialData> social;
    global RelatedData() {

    }
}
global class Representative extends tffa.AlloyDTO.BaseDTO {
    global List<tffa.AlloyDTO.Address> addresses;
    global Date birth_date;
    global String document_license;
    global String document_license_state;
    global String document_ssn;
    global String name_first;
    global String name_last;
    global String name_middle;
    global String phone_number;
    global String phone_number_work;
    global String type;
    global Representative() {

    }
    global tffa.AlloyDTO.Address addAddress() {
        return null;
    }
}
global class SocialData extends tffa.AlloyDTO.BaseDTO {
    global String id;
    global String type;
    global String url;
    global SocialData() {

    }
}
global class SourceData extends tffa.AlloyDTO.BaseDTO {
    global List<String> followup_codes;
    global List<String> reason_codes;
    global List<String> risk_codes;
    global SourceData() {

    }
}
global class SourceDataMatchResult extends tffa.AlloyDTO.BaseDTO {
    global Boolean matched;
    global Decimal score;
    global SourceDataMatchResult() {

    }
}
global class SourceDataMatchResults extends tffa.AlloyDTO.BaseDTO {
    global tffa.AlloyDTO.SourceDataMatchResult address;
    global tffa.AlloyDTO.SourceDataMatchResult dob;
    global tffa.AlloyDTO.SourceDataMatchResult name;
    global tffa.AlloyDTO.SourceDataMatchResult passport;
    global tffa.AlloyDTO.SourceDataMatchResult phone;
    global tffa.AlloyDTO.SourceDataMatchResult ssn;
    global SourceDataMatchResults() {

    }
}
global class WatchlistMatchResult extends tffa.AlloyDTO.BaseDTO {
    global Decimal confidence;
    global List<String> reasons;
    global String source;
    global String type;
    global WatchlistMatchResult() {

    }
}
global class WatchlistMatchResults extends tffa.AlloyDTO.BaseDTO {
    global List<String> lists;
    global List<tffa.AlloyDTO.WatchlistMatchResult> matches;
    global WatchlistMatchResults() {

    }
}
global class WebhookAlert extends tffa.AlloyDTO.BaseDTO {
    global String description;
    global String request_token;
    global Long timestamp;
    global String type;
    global WebhookAlert() {

    }
}
}
