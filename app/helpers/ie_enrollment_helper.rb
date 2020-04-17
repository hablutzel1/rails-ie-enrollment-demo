require 'base64'

module IeEnrollmentHelper

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
