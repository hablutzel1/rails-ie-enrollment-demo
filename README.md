# rails-ie-enrollment-demo

## Running the demo

To test this demonstration follow the next steps from a PC with Windows 10 and Internet Explorer 11:

1. Connect to `vpn.blobfish.pe` to be able to reach Blobfish's demo EJBCA CA (not required if the code is modified to connect to another EJBCA instance).
2. Then both `config/ssl/TestPurposeCA.cacert.pem` and `config/ejbca/BlobfishRootCAdemo.cacert.pem` should be installed in the "Trusted Root Certification Authorities" store for the current user.
3. Then start Puma with the following command: `puma -b 'ssl://0.0.0.0:3000?key=config/ssl/ieenrollment.example.org.key&cert=config/ssl/ieenrollment.example.org.pem'`.
2. Now, create an entry in `%WINDIR%\system32\drivers\etc\hosts` to associate `ieenrollment.example.org` to the IP where this demo is running (e.g. `127.0.0.1`).
4. Then configure `https://ieenrollment.example.org` as a Trusted site in Internet Explorer.
5. Finally, visit https://ieenrollment.example.org:3000 and make an initial enrollment test by selecting the "Microsoft Enhanced Cryptographic Provider v1.0" provider. 

If the previous enrollment operation works, enrolling with an specific smart card is just a matter of installing the correct smart card middleware and selecting the right provider. 

## Whitelisting providers

Modify `displayAllCsps` and `whitelistedCsps` directly in the VBScript code in `app/views/ie_enrollment/start.html.erb`.