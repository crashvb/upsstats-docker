FROM crashvb/nginx:202103282213
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

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
ADD default.nginx /etc/nginx/sites-available/default.template

# Configure: supervisor
RUN rm --force /etc/supervisor/conf.d/php.conf

# Configure: entrypoint
ADD entrypoint.nginx /etc/entrypoint.d/nginx
ADD entrypoint.upsstats /etc/entrypoint.d/upstats

# Configure: healthcheck
ADD healthcheck.nginx /etc/healthcheck.d/nginx

VOLUME ${NUT_CONFPATH}
