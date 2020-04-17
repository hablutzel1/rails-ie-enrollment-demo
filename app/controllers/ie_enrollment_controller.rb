require 'blobfish/ejbca'

class IeEnrollmentController < ApplicationController

  def start
  end

  def enroll
    # Receive CSR/PKCS #10 from the browser.
    csr_from_browser = params[:pkcs10]

    # Get/prepare data for certificate generation.
    tax_number = '20202020201'
    company_name = 'CONTOSO S.A.'
    title = 'General manager'
    nid = '20202020'
    surname = 'PEREZ VARGAS'
    given_name = 'JUAN CARLOS'
    email_address = 'jdoe@example.org'
    street_address = 'Av. Los Corales 123, San Isidro'
    locality = 'Lima'
    validated_by = 'Validated by XYZ'
    e = Blobfish::Ejbca::Client.method(:escape_dn_attr_value)
    ejbca_username = "llama_#{tax_number}_#{nid}"
    subject_dn = "CN=#{e[given_name]} #{e[surname]},emailAddress=#{e[email_address]},serialNumber=#{e[nid]},O=#{e[company_name]},OU=#{e[tax_number]},OU=#{e[validated_by]},T=#{e[title]},L=#{e[locality]},street=#{e[street_address]},C=PE"
    subject_alt_name = "rfc822name=#{email_address}"

    # Send PKCS #10 to EJBCA and receive a cert-only PKCS #7 (https://tools.ietf.org/html/rfc2797#section-7.1).
    ejbca_client = Blobfish::Ejbca::Client.new('https://blobfish-25.blobfish.pe:8443/ejbca/ejbcaws/ejbcaws?wsdl', 'config/ejbca/BlobfishRootCAdemo.cacert.pem', 'config/ejbca/app_llamape_ra_ejbca_client.cer', 'config/ejbca/app_llamape_ra_ejbca_client.key', 'secret', 'LlamaPeStandardCa', 'LlamaPePJEndUserNoApproval_CP', 'LlamaPePJEndUserNoNotification_EE')
    # TODO determine if the IE enrollment could work with a RESPONSETYPE_CERTIFICATE (but note that it could work better by having available the chain with the ICAs).
    pkcs7 = ejbca_client.request_from_csr(csr_from_browser, ejbca_username, email_address, subject_dn, subject_alt_name, :days_from_now, 365, Blobfish::Ejbca::Client::RESPONSETYPE_PKCS7WITHCHAIN)

    # Send the resulting cert-only PKCS #7 back to the browser.
    pkcs7_b64 = Base64.encode64(pkcs7.to_der)
    @cert_chain_as_vbs_string = helpers.ie_cert_format(pkcs7_b64)
  end

end
