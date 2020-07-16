package com.paytm.merchantsampleapp.model

import net.one97.paytm.nativesdk.common.model.BaseDataModel

data class UpiProfile(var respDetails: ResponseDetails?, var upiOnboarding:Boolean?) : BaseDataModel


data class ResponseDetails(var profileDetail: ProfileData?,
                           var metaDetails: MetaData?) : BaseDataModel

data class ProfileData(var vpaDetails: List<VpaAccountDetail>?,
                       var bankAccounts: List<VpaBankAccountDetail>?,
                       var profileStatus: String?,
                       var upiLinkedMobileNumber: String?,
                       var deviceBinded: Boolean) : BaseDataModel

interface BaseVpaDetail : BaseDataModel

data class VpaAccountDetail(var name: String?,
                            var defaultCreditAccRefId: String?,
                            var defaultDebitAccRefId: String?,
                            var primary: Boolean) : BaseDataModel

data class VpaBankAccountDetail(var bank: String? = null,
                                var ifsc: String? = null,
                                var accRefId: String? = null,
                                var maskedAccountNumber: String? = null,
                                var credsAllowed: List<CredsAllowed>? = null,
                                var accountType: String? = null,
                                var name: String? = null,
                                var mpinSet: String? = null,
                                var txnAllowed: String? = null,
                                var branchAddress: String? = null,
                                var bankMetaData: BankMetaData? = null,
                                var pgBankCode: String? = null,
                                var vpaDetail: VpaAccountDetail? = null) :
    BaseVpaDetail

data class CredsAllowed(var dLength: String?,
                        var CredsAllowedSubType: String?,
                        var CredsAllowedType: String?,
                        var CredsAllowedDLength: String?,
                        var CredsAllowedDType: String?) : BaseDataModel

data class BankMetaData(var perTxnLimit: String?,
                        var bankHealth: BankHealth?) : BaseDataModel

data class BankHealth(var category: String?,
                      var displayMsg: String?) : BaseDataModel


data class MetaData(var npciHealthCategory: String?,
                    var npciHealthMsg: String?) : BaseDataModel