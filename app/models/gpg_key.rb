require 'gitlab/gpg'

class GpgKey < ApplicationRecord
  KEY_PREFIX = '-----BEGIN PGP PUBLIC KEY BLOCK-----'.freeze
  KEY_SUFFIX = '-----END PGP PUBLIC KEY BLOCK-----'.freeze

  belongs_to :user

  validates :user, presence: true

  validates :key,
            presence:   true,
            uniqueness: true,
            format: {
                with: /\A#{KEY_PREFIX}((?!#{KEY_PREFIX})(?!#{KEY_SUFFIX}).)+#{KEY_SUFFIX}\Z/m,
                message: "is invalid. A valid public GPG key begins with '#{KEY_PREFIX}' and ends with '#{KEY_SUFFIX}'"
            }

  validates :fingerprint,
            presence:   true,
            uniqueness: true,
            # only validate when the `key` is valid, as we don't want the user to show
            # the error about the fingerprint
            unless: -> { errors.has_key?(:key) }

  validates :primary_keyid,
            presence:   true,
            uniqueness: true,
            # only validate when the `key` is valid, as we don't want the user to show
            # the error about the key ID
            unless: -> { errors.has_key?(:key) }

  before_destroy :delete_from_keychain
  before_validation :extract_fingerprint, :extract_primary_keyid

  def primary_keyid
    super&.upcase
  end

  alias_method :keyid, :primary_keyid

  def fingerprint
    super&.upcase
  end

  def key=(value)
    super(value&.strip)
  end

  private

  def delete_from_keychain
    # Ensure the key is deleted from the local keychain when a user
    # removes the key from their profile
    Gitlab::Gpg::CurrentKeyChain.delete(user.email)
  end

  def extract_fingerprint
    # we can assume that the result only contains one item as the validation
    # only allows one key
    self.fingerprint = Gitlab::Gpg.fingerprints_from_key(key).first
  end

  def extract_primary_keyid
    # we can assume that the result only contains one item as the validation
    # only allows one key
    self.primary_keyid = Gitlab::Gpg.primary_keyids_from_key(key).first
  end
end
