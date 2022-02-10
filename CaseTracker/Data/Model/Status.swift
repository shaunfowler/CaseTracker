//
//  Status.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/2/22.
//

import Foundation
import SwiftUI

enum Status: String {
    case advanceParoleDocumentWasProduced = "Advance Parole Document Was Produced"
    case amendedNoticeWasMailed = "Amended Notice Was Mailed"
    case appealWasRemandedToTheOriginatingOfficeForConsideration = "Appeal Was Remanded To The Originating Office For Consideration"
    case biometricsAppointmentWasScheduled = "Biometrics Appointment Was Scheduled"
    case cardDestroyed = "Card Destroyed"
    case cardIsBeingReturnedtoUSCISbyPostOffice = "Card Is Being Returned to USCIS by Post Office"
    case cardWasDeliveredToMeByThePostOffice = "Card Was Delivered To Me By The Post Office"
    case cardWasDestroyed = "Card Was Destroyed"
    case cardWasMailedToMe = "Card Was Mailed To Me"
    case cardWasPickedUpByTheUnitedStatesPostalService = "Card Was Picked Up By The United States Postal Service"
    case cardWasReceivedByUSCISAlongWithMyLetter = "Card Was Received By USCIS Along With My Letter"
    case cardWasReturnedToUSCIS = "Card Was Returned To USCIS"
    case caseAcceptedByTheUSCISLockbox = "Case Accepted By The USCIS Lockbox"
    case caseApprovalWasCertifiedByUSCIS = "Case Approval Was Certified By USCIS"
    case caseApprovalWasReaffirmedAndMailedBackToDepartmentOfState = "Case Approval Was Reaffirmed And Mailed Back To Department Of State"
    case caseApprovalWasRevoked = "Case Approval Was Revoked"
    case caseClosedBenefitReceivedByOtherMeans = "Case Closed Benefit Received By Other Means"
    case caseIsOnHold = "Case Is On Hold"
    case caseIsPendingataLocalOffice = "Case Is Pending at a Local Office"
    case caseisReadytoBeScheduledforAnInterview = "Case is Ready to Be Scheduled for An Interview"
    case caseRejectedBecauseISentAnIncorrectFee = "Case Rejected Because I Sent An Incorrect Fee"
    case caseRejectedBecauseTheVersionOfTheFormISentIsNoLongerAccepted = "Case Rejected Because The Version Of The Form I Sent Is No Longer Accepted"
    case caseRejectedForFormNotSignedAndIncorrectFormVersion = "Case Rejected For Form Not Signed And Incorrect Form Version"
    case caseRejectedForIncorrectFee = "Case Rejected For Incorrect Fee"
    case caseRejectedForIncorrectFeeAndFormNotSigned = "Case Rejected For Incorrect Fee And Form Not Signed"
    case caseRejectedForIncorrectFeeAndIncorrectFormVersion = "Case Rejected For Incorrect Fee And Incorrect Form Version"
    case caseRejectedForIncorrectFeeAndPaymentNotSigned = "Case Rejected For Incorrect Fee And Payment Not Signed"
    case caseTransferredAndNewOfficeHasJurisdiction = "Case Transferred And New Office Has Jurisdiction"
    case caseTransferredToAnotherOffice = "Case Transferred To Another Office"
    case caseWasApproved = "Case Was Approved"
    case caseWasApprovedAndUSCISNotifiedTheUSConsulateorPortofEntry = "Case Was Approved And USCIS Notified The U.S. Consulate or Port of Entry"
    case caseWasAutomaticallyRevoked = "Case Was Automatically Revoked"
    case caseWasDenied = "Case Was Denied"
    case caseWasDeniedAndMyDecisionNoticeMailed = "Case Was Denied And My Decision Notice Mailed"
    case caseWasNotRevokedorCancelledByUSCIS = "Case Was Not Revoked or Cancelled By USCIS"
    case caseWasReceived = "Case Was Received"
    case caseWasReceivedandAReceiptNoticeWasEmailed = "Case Was Received and A Receipt Notice Was Emailed"
    case caseWasReceivedAtAnotherUSCISOffice = "Case Was Received At Another USCIS Office"
    case caseWasRejectedBecauseIDidNotSignMyForm = "Case Was Rejected Because I Did Not Sign My Form"
    case caseWasRejectedBecauseItWasImproperlyFiled = "Case Was Rejected Because It Was Improperly Filed"
    case caseWasRejectedBecauseMyCheckOrMoneyOrderIsNotSigned = "Case Was Rejected Because My Check Or Money Order Is Not Signed"
    case caseWasRelocatedFromAdministrativeAppealsOfficeToUSCISOriginatingOffice = "Case Was Relocated From Administrative Appeals Office To USCIS Originating Office"
    case caseWasReopened = "Case Was Reopened"
    case caseWasReopenedForReconsideration = "Case Was Reopened For Reconsideration"
    case caseWasReturnedToUSCISByTheExecutiveOfficeofImmigrationReview = "Case Was Returned To USCIS By The Executive Office of Immigration Review"
    case caseWasSentToTheAdministrativeAppealsOfficeforReview = "Case Was Sent To The Administrative Appeals Office for Review"
    case caseWasSentToTheDepartmentofState = "Case Was Sent To The Department of State"
    case caseWasSentToTheExecutiveOfficeofImmigrationReview = "Case Was Sent To The Executive Office of Immigration Review"
    case caseWasTransferredAndANewOfficeHasJurisdiction = "Case Was Transferred And A New Office Has Jurisdiction"
    case caseWasTransferredToAnAsylumOffice = "Case Was Transferred To An Asylum Office"
    case caseWasTransferredToInternationalOfficeConsulate = "Case Was Transferred To International Office/Consulate"
    case caseWasTransferredToScheduleAnInterview = "Case Was Transferred To Schedule An Interview"
    case caseWasUpdatedToShowFingerprintsWereTaken = "Case Was Updated To Show Fingerprints Were Taken"
    case caseWasUpdatedToShowThatNoOneAppearedforInPersonProcessing = "Case Was Updated To Show That No One Appeared for In-Person Processing"
    case certifiedApprovalOfMyCaseWasReversedbyTheAppellateAuthority = "Certified Approval Of My Case Was Reversed by The Appellate Authority"
    case cNMISemiannualReportReceived = "CNMI Semiannual Report Received"
    case continuationNoticeWasMailed = "Continuation Notice Was Mailed"
    case correspondenceWasReceivedAndUSCISIsReviewingIt = "Correspondence Was Received And USCIS Is Reviewing It"
    case cWRNoticeofIntenttoRevokeSent = "CWR Notice of Intent to Revoke Sent"
    case dateofBirthWasUpdated = "Date of Birth Was Updated"
    case departmentofStateSentCasetoUSCISForReview = "Department of State Sent Case to USCIS For Review"
    case documentAndLetterWasReceivedAndUnderReview = "Document And Letter Was Received And Under Review"
    case documentDestroyed = "Document Destroyed"
    case documentIsBeingHeldFor180Days = "Document Is Being Held For 180 Days"
    case documentWasMailedToMe = "Document Was Mailed To Me"
    case documentWasReturnedAsUndeliverable = "Document Was Returned As Undeliverable"
    case documentWasReturnedToUSCIS = "Document Was Returned To USCIS"
    case documentWasReturnedToUSCISAndIsBeingHeld = "Document Was Returned To USCIS And Is Being Held"
    case duplicateNoticeWasMailed = "Duplicate Notice Was Mailed"
    case eligibilityNoticeWasMailed = "Eligibility Notice Was Mailed"
    case expediteRequestApproved = "Expedite Request Approved"
    case expediteRequestDenied = "Expedite Request Denied"
    case expediteRequestReceived = "Expedite Request Received"
    case feeRefundWasMailed = "Fee Refund Was Mailed"
    case feesWereWaived = "Fees Were Waived"
    case feeWillBeRefunded = "Fee Will Be Refunded"
    case filedUnderKnownEmployerPilot = "Filed Under Known Employer Pilot"
    case fingerprintandBiometricsAppointmentWasScheduled = "Fingerprint and Biometrics Appointment Was Scheduled"
    case fingerprintFeeWasReceived = "Fingerprint Fee Was Received"
    case formG28WasRejectedBecauseItWasImproperlyFiled = "Form G-28 Was Rejected Because It Was Improperly Filed"
    case intentToRescindNoticeWasMailed = "Intent To Rescind Notice Was Mailed"
    case intenttoRevokeNoticeWasSent = "Intent to Revoke Notice Was Sent"
    case interviewCancelled = "Interview Cancelled"
    case interviewCancelledAndNoticeOrdered = "Interview Cancelled And Notice Ordered"
    case interviewWasRescheduled = "Interview Was Rescheduled"
    case interviewWasScheduled = "Interview Was Scheduled"
    case litigationNoticeWasMailed = "Litigation Notice Was Mailed"
    case nameWasUpdated = "Name Was Updated"
    case newCardIsBeingProduced = "New Card Is Being Produced"
    case noticeExplainingUSCISActionsWasMailed = "Notice Explaining USCIS Actions Was Mailed"
    case noticeWasReturnedToUSCISBecauseThePostOfficeCouldNotDeliverIt = "Notice Was Returned To USCIS Because The Post Office Could Not Deliver It"
    case petitionApplicationWasRejectedForInsufficientFunds = "Petition/Application Was Rejected For Insufficient Funds"
    case petitionWithdrawnOver180DaysNotAutomaticallyRevoked = "Petition Withdrawn/Over 180 Days/Not Automatically Revoked"
    case premiumProcessingCaseisNotEligibleforPreCertification = "Premium Processing Case is Not Eligible for Pre-Certification"
    case premiumProcessingFeeWillBeRefunded = "Premium Processing Fee Will Be Refunded"
    case reentryPermitWasProduced = "Reentry Permit Was Produced"
    case refugeeTravelDocumentWasProduced = "Refugee Travel Document Was Produced"
    case requestforAdditionalEvidenceWasSent = "Request for Additional Evidence Was Sent"
    case requestforAdditionalInformationReceived = "Request for Additional Information Received"
    case requestForADuplicateCardWasApproved = "Request For A Duplicate Card Was Approved"
    case requestforInitialEvidenceWasSent = "Request for Initial Evidence Was Sent"
    case requestForInitialEvidenceWasSent = "Request For Initial Evidence Was Sent"
    case requestForPremiumProcessingServicesWasReceived = "Request For Premium Processing Services Was Received"
    case requestToRescheduleMyAppointmentWasReceived = "Request To Reschedule My Appointment Was Received"
    case requestWasProcessed = "Request Was Processed"
    case requestWasRejected = "Request Was Rejected"
    case responseToUSCISRequestForEvidenceWasReceived = "Response To USCIS' Request For Evidence Was Received"
    case resubmittedFeeWasNotAccepted = "Resubmitted Fee Was Not Accepted"
    case revocationNoticeWasSent = "Revocation Notice Was Sent"
    case statusTerminationNoticeWasMailed = "Status Termination Notice Was Mailed"
    case terminationOfLitigationNoticeWasMailed = "Termination Of Litigation Notice Was Mailed"
    case travelDocumentWasDestroyedAfterUSCISHeldItFor180Days = "Travel Document Was Destroyed After USCIS Held It For 180 Days"
    case travelDocumentWasMailed = "Travel Document Was Mailed"
    case travelDocumentWasReturnedtoUSCISAndWillBeHeldFor180Days = "Travel Document Was Returned to USCIS And Will Be Held For 180 Days"
    case withdrawalAcknowledgementNoticeWasSent = "Withdrawal Acknowledgement Notice Was Sent"
    case withdrawalOfMyAppealWasAcknowledged = "Withdrawal Of My Appeal Was Acknowledged"
    case caseWasApprovedAndMyDecisionWasEmailed = "Case Was Approved And My Decision Was Emailed" // custom

    var color: Color {
        switch self {
        case .advanceParoleDocumentWasProduced,
                .cardWasDeliveredToMeByThePostOffice,
                .cardWasMailedToMe,
                .cardWasPickedUpByTheUnitedStatesPostalService,
                .caseApprovalWasCertifiedByUSCIS,
                .caseApprovalWasReaffirmedAndMailedBackToDepartmentOfState,
                .caseClosedBenefitReceivedByOtherMeans,
                .caseWasApproved,
                .caseWasApprovedAndUSCISNotifiedTheUSConsulateorPortofEntry,
                .documentWasMailedToMe,
                .expediteRequestApproved,
                .newCardIsBeingProduced,
                .reentryPermitWasProduced,
                .refugeeTravelDocumentWasProduced,
                .requestForADuplicateCardWasApproved,
                .travelDocumentWasMailed,
                .caseWasApprovedAndMyDecisionWasEmailed
            :
            return Color("CTGreen")

        case .caseApprovalWasRevoked,
                .caseRejectedBecauseISentAnIncorrectFee,
                .caseRejectedBecauseTheVersionOfTheFormISentIsNoLongerAccepted,
                .caseRejectedForFormNotSignedAndIncorrectFormVersion,
                .caseRejectedForIncorrectFee,
                .caseRejectedForIncorrectFeeAndFormNotSigned,
                .caseRejectedForIncorrectFeeAndIncorrectFormVersion,
                .caseRejectedForIncorrectFeeAndPaymentNotSigned,
                .caseWasDenied,
                .caseWasDeniedAndMyDecisionNoticeMailed,
                .caseWasRejectedBecauseIDidNotSignMyForm,
                .caseWasRejectedBecauseItWasImproperlyFiled,
                .caseWasRejectedBecauseMyCheckOrMoneyOrderIsNotSigned,
                .caseWasRelocatedFromAdministrativeAppealsOfficeToUSCISOriginatingOffice,
                .certifiedApprovalOfMyCaseWasReversedbyTheAppellateAuthority,
                .intenttoRevokeNoticeWasSent,
                .petitionApplicationWasRejectedForInsufficientFunds,
                .petitionWithdrawnOver180DaysNotAutomaticallyRevoked,
                .revocationNoticeWasSent,
                .statusTerminationNoticeWasMailed
            :

            return Color("CTRed")

        case .interviewWasRescheduled,
                .interviewWasScheduled,
                .premiumProcessingCaseisNotEligibleforPreCertification,
                .requestforAdditionalEvidenceWasSent,
                .requestforAdditionalInformationReceived,
                .requestforInitialEvidenceWasSent,
                .requestForInitialEvidenceWasSent,
                .resubmittedFeeWasNotAccepted,
                .terminationOfLitigationNoticeWasMailed

            :
            return Color("CTYellow")

        case .cardIsBeingReturnedtoUSCISbyPostOffice,
                .cardWasReturnedToUSCIS,
                .caseWasUpdatedToShowThatNoOneAppearedforInPersonProcessing,
                .cWRNoticeofIntenttoRevokeSent,
                .documentIsBeingHeldFor180Days,
                .documentWasReturnedAsUndeliverable,
                .documentWasReturnedToUSCIS,
                .documentWasReturnedToUSCISAndIsBeingHeld,
                .expediteRequestDenied,
                .interviewCancelled,
                .interviewCancelledAndNoticeOrdered,
                .noticeWasReturnedToUSCISBecauseThePostOfficeCouldNotDeliverIt,
                .requestWasRejected,
                .travelDocumentWasDestroyedAfterUSCISHeldItFor180Days,
                .travelDocumentWasReturnedtoUSCISAndWillBeHeldFor180Days
            :
            return Color("CTOrange")

        case .cardDestroyed,
                .caseIsOnHold,
                .caseIsPendingataLocalOffice,
                .caseWasAutomaticallyRevoked,
                .caseWasNotRevokedorCancelledByUSCIS,
                .documentDestroyed
            :
            return Color("CTGray")

        default:
            if rawValue.contains("Case Was Approved") {
                return Color("CTGreen")
            }
            if rawValue.contains("Case Rejected") || rawValue.contains("Case Was Rejected") {
                return Color("CTRed")
            }
            return Color("CTBlue")
        }
    }
}
