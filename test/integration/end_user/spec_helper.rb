TEST_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../../'))

def dummy_identity
  File.expand_path("#{TEST_ROOT}/integration/dummy_identity")
end

def dummy_work
  File.expand_path("#{TEST_ROOT}/integration/dummy_work")
end

def real_identity
  File.expand_path("#{TEST_ROOT}/integration/end_user/real_identity")
end

def docker_image
  "#{ENV['AIT_DOCKER_IMAGE_NAME']}:"\
  "#{ENV['AIT_DOCKER_IMAGE_TAG']}"
end

# improving String class
class String
  def cyan
    "\033[36m#{self}\033[0m"
  end
end
