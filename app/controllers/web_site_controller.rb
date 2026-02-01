class WebSiteController < ApplicationController
 skip_before_action :authorize_request

 def blogs_landing
    blogs= Blog.published.map do |blog|
      {
        id: blog.id,
        title_ar: blog.title_ar,
        title_en: blog.title_en,
        description_ar: blog.description_ar,
        description_en: blog.description_en,
        category: blog.category,
        slug: blog.slug,
        slug_ar: blog.slug_ar,
        photos: blog.blog_photos.map do |photo|
          {
            id: photo.id,
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
            is_arabic: photo.is_arabic
          }
        end
      }
    end
    render json: blogs
  end

  def blog_show
    blog = Blog.find_by_any_slug(params[:slug])
    data = {
          id: blog.id,
          title_ar: blog.title_ar,
          title_en: blog.title_en,
          category: blog.category,
          slug: blog.slug,
          slug_ar: blog.slug_ar,
          meta_description_ar: blog.meta_description_ar,
          meta_description_en: blog.meta_description_en,
          meta_title_ar: blog.meta_title_ar,
          meta_title_en: blog.meta_title_en,
          is_published: blog.is_published,
          is_highlighted: blog.is_highlighted,
          photos: blog.blog_photos.map do |photo|
            {
              id: photo.id,
              url: photo.photo.attached? ? url_for(photo.photo) : nil,
              alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
              is_arabic: photo.is_arabic
            }
          end,
          contents: blog.contents.where(is_deleted: false).order(:id).map do |content|
            {
              id: content.id,
              content_ar: content.content_ar,
              content_en: content.content_en,
              is_published: content.is_published,
              photos: content.content_photos.map do |cp|
                {
                  id: cp.id,
                  url: cp.photo.attached? ? url_for(cp.photo) : nil,
                  alt_ar: cp.alt_ar,
                  alt_en: cp.alt_en
                }
              end
            }
          end,
          faqs: blog.faqs.where(is_deleted: false).order(:id).map do |faq|
            {
              id: faq.id,
              question_ar: faq.question_ar,
              question_en: faq.question_en,
              answer_ar: faq.answer_ar,
              answer_en: faq.answer_en,
              is_published: faq.is_published
            }
          end
        }

    render json: data
  end

  def products
    products = Product.published.map do |product|
      {
        id: product.id,
        description_ar: product.description_ar,
        description_en: product.description_en,
        category: product.category,
        photos: product.product_photos.map do |photo|
          {
            id: photo.id,
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
            is_arabic: photo.is_arabic
          }
        end
      }
    end
    render json: products
  end

  def faq_about_us
    faqs = Faq.where(is_deleted: false, is_published: true, parentable_id: nil).order(:id)
      render json: faqs.map { |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en
      }
    }
  end
end