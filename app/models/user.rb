class User < ActiveRecord::Base

	mount_uploader :profile_pic, ProfilePicUploader
	after_save :enqueue_image

	validates_presence_of :name, :on => :create

	def image_name
		File.basename(image.path || image.filename) if image
	end

	def enqueue_image
		ImageWorker.perform_async(id, key) if key.present?
	end

	class ImageWorker
		include Sidekiq::Worker

		def perform(id, key)
			user = User.find(id)
			user.key = key
			user.remote_image_url = user.profile_pic.direct_fog_url(with_path: true)
			user.save!
			user.update_column(:image_processed, true)
		end
	end
end
