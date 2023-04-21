module Api::PaginatedCollection
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  protected

  def build_paginator_for(collection)
    paginator.call(collection, params: page_params, base_url: request.url)
  end

  def page_params
    # avoid to return HTTP 400 when client doesn't set pagination parameter
    return {} unless params.key?(:page)

    params.require(:page).permit(:size, :number)
  end

  def paginator
    @paginator ||= JSOM::Pagination::Paginator.new
  end

  def paginate(collection, serializer_class, additional_options = {})
    paginated_collection = build_paginator_for(collection)
    options = {
      is_collection: true,
      meta: paginated_collection.meta.to_h,
      links: paginated_collection.links.to_h
    }

    serializer_class.new(paginated_collection.items, options.merge(additional_options))
  end
end
