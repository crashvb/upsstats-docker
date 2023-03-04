FROM crashvb/nginx:202303040000@sha256:747c2bc7e0d1ce314c9b818e39be22ce27a444a8566ec068bd0612ad7163ef3e
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:747c2bc7e0d1ce314c9b818e39be22ce27a444a8566ec068bd0612ad7163ef3e" \
	org.opencontainers.image.base.name="crashvb/nginx:202303040000" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing upsstats." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/upsstats-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/upsstats" \
	org.opencontainers.image.url="https://github.com/crashvb/upsstats-docker"

# Install packages, download files ...
RUN docker-apt nut-cgi

# Configure: upsstats
ENV NUT_CONFPATH=/etc/nut
RUN install --directory --group=root --mode=0775 --owner=root /usr/local/share/nut && \
	sed --expression="/^### I_HAVE/s/^### //" \
		--in-place=.dist ${NUT_CONFPATH}/upsset.conf && \
	mv ${NUT_CONFPATH} /usr/local/share/nut/config && \
	mv /usr/lib/cgi-bin /usr/share/nut/www/

# Configure: nginx
COPY default.nginx /etc/nginx/sites-available/default.template

# Configure: supervisor
RUN rm --force /etc/supervisor/conf.d/php.conf

# Configure: entrypoint
COPY entrypoint.nginx /etc/entrypoint.d/nginx
COPY entrypoint.upsstats /etc/entrypoint.d/upstats

VOLUME ${NUT_CONFPATH}
