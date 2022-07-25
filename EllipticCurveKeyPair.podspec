Pod::Spec.new do |s|
  s.name         = "EllipticCurveKeyPair"
  s.version      = "2.0.2"
  s.summary      = "Sign, verify, encrypt and decrypt using the Secure Enclave"
  s.description  = <<-DESC
    Create and manage an Elliptic Curve Key Pair on the Secure Enclave on iOS or MacOS.
  DESC
  s.homepage     = "https://github.com/1KBlockID/EllipticCurveKeyPair.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Kuldeep" => "kuldeep@1kosmos.com" }
  s.platform = :ios
  s.ios.deployment_target = "12.0"
  s.source       = { :git => "https://github.com/1KBlockID/EllipticCurveKeyPair.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = ["Foundation", "LocalAuthentication", "Security"]
  s.swift_version = '5.5'
end
