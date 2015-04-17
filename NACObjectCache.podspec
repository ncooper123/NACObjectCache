Pod::Spec.new do |s|
  s.name         = "NACObjectCache"
  s.version      = "0.0.4"
  s.summary      = "A helper class for performing Core Data lookups."

  s.description  = "A helper class for performing Core Data lookups."

  s.homepage = "https://github.com/ncooper123/"
  s.license = { :type => 'BSD' }
  s.author = { "Nathan" => "ncooper@uno.edu" }
  s.platform = :ios
  s.requires_arc = true
  s.source = { :git => "https://github.com/ncooper123/NACObjectCache", :branch => "master", :tag => '0.0.4' }
  s.source_files = "*.{h,m}"

end
