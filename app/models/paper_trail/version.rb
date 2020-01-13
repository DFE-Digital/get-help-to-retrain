module PaperTrail
  class Version < RestrictedActiveRecordBase
    include PaperTrail::VersionConcern
  end
end
