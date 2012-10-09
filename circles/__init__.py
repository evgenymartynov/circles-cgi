from pyramid.config import Configurator
from sqlalchemy import engine_from_config
from pyramid.session import UnencryptedCookieSessionFactoryConfig
from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from circles.models import initialize_sql

# Shortcut for adding new routes
def new_route(config, path, view_name, route_name='', renderer=None, permission=None):
    route_name = route_name or view_name.replace('.', '_')
    config.add_route(route_name, path)
    config.add_view(view_name, route_name=route_name,
                    renderer=renderer, permission=permission)

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """

    # Auth stuff
    sessfact = UnencryptedCookieSessionFactoryConfig('not very secret after all')
    authentication_policy = AuthTktAuthenticationPolicy('eat me')
    authorisation_policy = ACLAuthorizationPolicy()

    config = Configurator(settings=settings,
                            session_factory=sessfact,
                            authentication_policy=authentication_policy,
                            authorization_policy=authorisation_policy )

#
# Routes
#
    config.add_static_view('static', 'circles:static', cache_max_age=3600)

    new_route(config, path='/favicon.ico',
                    route_name='favicon',
                    view_name='circles.views.FaviconView')

# Publics
    new_route(config, path='/',
                    route_name='main',
                    view_name='circles.views.Main',
                    renderer='front-page.mako')
    new_route(config, path='/link',
                    route_name='timetable_link',
                    view_name='circles.views.TimetableLink',
                    renderer='front-page.mako')
    new_route(config, path='/admin',
                    route_name='admin',
                    view_name='circles.views.Admin')

    return config.make_wsgi_app()

