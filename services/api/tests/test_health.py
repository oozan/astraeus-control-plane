from app.main import health_check


def test_health_endpoint() -> None:
    response = health_check()
    assert response["status"] == "ok"
