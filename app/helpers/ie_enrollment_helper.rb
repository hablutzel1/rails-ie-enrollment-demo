require 'base64'

module IeEnrollmentHelper

  # FIXME: very similar logic in Blobfish::Ejbca::Client#request_from_csr, i.e. just modifying the response type. Determine if the IE enrollment could work with a RESPONSETYPE_CERTIFICATE (but note that it could work better by having available the chain with the ICAs) and then move (if required) this logic to 'blobfish-ejbca-client-ruby'. Another option would be to make 'request_from_csr' always return a PKCS #7. Another possibility would be that 'request_from_csr' simply receives the expected return type as an argument and returns the raw response bytes or an object, i.e. Blobfish::Ejbca::Certificate or OpenSSL::PKCS7 (just remember to increase the gem version as this is an API change).
  def request_pkcs7_from_csr(ejbca_client, pem_csr, ejbca_username, email_address, subject_dn, subject_alt_name, validity_type, validity_value)
    end_user = ejbca_client.send :create_end_user, ejbca_username, nil, Blobfish::Ejbca::Client::TOKEN_TYPE_USERGENERATED, email_address, subject_dn, subject_alt_name, validity_type, validity_value
    ws_resp = ejbca_client.send :ws_call, :certificate_request,
                                arg0: end_user,
                                arg1: pem_csr,
                                arg2: 0,
                                arg4: 'PKCS7WITHCHAIN'
    pkcs7_as_der = Blobfish::Ejbca::Client.double_decode64(ws_resp[:data])
    OpenSSL::PKCS7.new(pkcs7_as_der)
  end

  # TODO: understand the syntax expected by VBScript and compare the following against the implementation in EJBCA (org.ejbca.ui.web.RequestHelper#ieCertFormat. See too org.ejbca.ui.web.pub.ServletDebug#ieCertFix).
  def ie_cert_format(pkcs7_b64)
    line_idx = 0
    output = ''
    pkcs7_b64.each_line do |line|
      line.rstrip!
      # TODO: confirm why does it apparently produce an empty line at the end and then clarify the current code.
      next if line.to_s == ''

      if (line_idx += 1) > 1
        output << ' & _ '
        output << "\n"
      else
        output << 'cert = '
      end
      output << "\"#{line}\""
    end
    output << "\n"
    output
  end
end
