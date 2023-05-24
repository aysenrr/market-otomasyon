--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: customer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA customer;


ALTER SCHEMA customer OWNER TO postgres;

--
-- Name: payment; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA payment;


ALTER SCHEMA payment OWNER TO postgres;

--
-- Name: add_tax(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_tax(payment_type text, ucret integer, adet integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF payment_type = 'debit' THEN
    RETURN (ucret + (ucret * 0.1))*adet;
  ELSE
    RETURN ucret*adet;
  END IF;
END;
$$;


ALTER FUNCTION public.add_tax(payment_type text, ucret integer, adet integer) OWNER TO postgres;

--
-- Name: apply_discount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.apply_discount() RETURNS TABLE(_product_id integer, namee character varying, pricee integer, stockk integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE product SET price = price * 0.9;
  RETURN Query
  Select "product_id","name","price","stock" from product;
END;
$$;


ALTER FUNCTION public.apply_discount() OWNER TO postgres;

--
-- Name: calculate_result(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_result(ucret integer, adet integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 
  result INTEGER;
BEGIN
    result := ucret * adet;

  RETURN result;
END;
$$;


ALTER FUNCTION public.calculate_result(ucret integer, adet integer) OWNER TO postgres;

--
-- Name: create_low_stock_record(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_low_stock_record() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.stock < 15 THEN
    INSERT INTO low_product (product_id, name, stock, price)
    VALUES (NEW.product_id, NEW.name, NEW.stock, NEW.price);
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.create_low_stock_record() OWNER TO postgres;

--
-- Name: login(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login(_employee_id integer, _name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
   if (SELECT count(*) from public.employee where "name"=_name and"employee_id"=_employee_id)>0 then 
      return 1;
   else
      return 0; 
   end if;
end
   $$;


ALTER FUNCTION public.login(_employee_id integer, _name character varying) OWNER TO postgres;

--
-- Name: searchproduct(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.searchproduct(ename text) RETURNS TABLE(_productid integer, _productname character varying, _price integer, _stock integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "product_id","name","price","stock" FROM product
                 WHERE "name"=ename;
END;
$$;


ALTER FUNCTION public.searchproduct(ename text) OWNER TO postgres;

--
-- Name: sort_products_by_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sort_products_by_price() RETURNS TABLE(naame character varying, ppprice integer, ssstock integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
  RETURN QUERY
    SELECT "name",price,stock
    FROM product
    ORDER BY price ASC;
END;
$$;


ALTER FUNCTION public.sort_products_by_price() OWNER TO postgres;

--
-- Name: update_employee_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_employee_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Update the count column in the employee_count table
  UPDATE employee_count SET id = (SELECT COUNT(*) FROM employee);

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_employee_count() OWNER TO postgres;

--
-- Name: update_hire_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_hire_info() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.id > 10 THEN
     Update hire_info Set info ='Enough Employee number';
  ELSE  
  Update hire_info SET info='Hire new Employees';
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_hire_info() OWNER TO postgres;

--
-- Name: update_stock_table(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_stock_table() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM stock WHERE name = NEW.name) THEN
    INSERT INTO stock (name, total_stock) VALUES (NEW.name, NEW.stock);
  ELSE
    UPDATE stock SET total_stock = total_stock + NEW.stock WHERE name = NEW.name;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stock_table() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer (
    customer_id integer NOT NULL,
    name character varying,
    surname character varying,
    customer_type character varying,
    city character varying,
    e_mail character varying,
    contact_no character varying
);


ALTER TABLE customer.customer OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_customer_id_seq OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_customer_id_seq OWNED BY customer.customer.customer_id;


--
-- Name: individual; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.individual (
    customer_id integer NOT NULL,
    age integer,
    gender character varying
);


ALTER TABLE customer.individual OWNER TO postgres;

--
-- Name: individual_customer_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.individual_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.individual_customer_id_seq OWNER TO postgres;

--
-- Name: individual_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.individual_customer_id_seq OWNED BY customer.individual.customer_id;


--
-- Name: institutional; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.institutional (
    customer_id integer NOT NULL
);


ALTER TABLE customer.institutional OWNER TO postgres;

--
-- Name: institutional_customer_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.institutional_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.institutional_customer_id_seq OWNER TO postgres;

--
-- Name: institutional_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.institutional_customer_id_seq OWNED BY customer.institutional.customer_id;


--
-- Name: cash; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.cash (
    payment_id integer NOT NULL
);


ALTER TABLE payment.cash OWNER TO postgres;

--
-- Name: cash_payment_id_seq; Type: SEQUENCE; Schema: payment; Owner: postgres
--

CREATE SEQUENCE payment.cash_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment.cash_payment_id_seq OWNER TO postgres;

--
-- Name: cash_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: payment; Owner: postgres
--

ALTER SEQUENCE payment.cash_payment_id_seq OWNED BY payment.cash.payment_id;


--
-- Name: debit_card; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.debit_card (
    payment_id integer NOT NULL
);


ALTER TABLE payment.debit_card OWNER TO postgres;

--
-- Name: debit_card_payment_id_seq; Type: SEQUENCE; Schema: payment; Owner: postgres
--

CREATE SEQUENCE payment.debit_card_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment.debit_card_payment_id_seq OWNER TO postgres;

--
-- Name: debit_card_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: payment; Owner: postgres
--

ALTER SEQUENCE payment.debit_card_payment_id_seq OWNED BY payment.debit_card.payment_id;


--
-- Name: payment; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.payment (
    payment_id integer NOT NULL,
    customer_id integer NOT NULL,
    price integer NOT NULL,
    variety_id integer NOT NULL,
    payment_type character varying,
    sales_name character varying,
    quantity integer
);


ALTER TABLE payment.payment OWNER TO postgres;

--
-- Name: payment_customer_id_seq; Type: SEQUENCE; Schema: payment; Owner: postgres
--

CREATE SEQUENCE payment.payment_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment.payment_customer_id_seq OWNER TO postgres;

--
-- Name: payment_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: payment; Owner: postgres
--

ALTER SEQUENCE payment.payment_customer_id_seq OWNED BY payment.payment.customer_id;


--
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: payment; Owner: postgres
--

CREATE SEQUENCE payment.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment.payment_payment_id_seq OWNER TO postgres;

--
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: payment; Owner: postgres
--

ALTER SEQUENCE payment.payment_payment_id_seq OWNED BY payment.payment.payment_id;


--
-- Name: payment_variety_id_seq; Type: SEQUENCE; Schema: payment; Owner: postgres
--

CREATE SEQUENCE payment.payment_variety_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment.payment_variety_id_seq OWNER TO postgres;

--
-- Name: payment_variety_id_seq; Type: SEQUENCE OWNED BY; Schema: payment; Owner: postgres
--

ALTER SEQUENCE payment.payment_variety_id_seq OWNED BY payment.payment.variety_id;


--
-- Name: brand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brand (
    brand_id integer NOT NULL,
    name character varying,
    supplier_id integer NOT NULL
);


ALTER TABLE public.brand OWNER TO postgres;

--
-- Name: brand_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brand_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brand_brand_id_seq OWNER TO postgres;

--
-- Name: brand_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brand_brand_id_seq OWNED BY public.brand.brand_id;


--
-- Name: brand_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brand_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brand_supplier_id_seq OWNER TO postgres;

--
-- Name: brand_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brand_supplier_id_seq OWNED BY public.brand.supplier_id;


--
-- Name: company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company (
    company_id integer NOT NULL,
    name character varying,
    city character varying,
    contact_no character varying
);


ALTER TABLE public.company OWNER TO postgres;

--
-- Name: company_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_company_id_seq OWNER TO postgres;

--
-- Name: company_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_company_id_seq OWNED BY public.company.company_id;


--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    department_id integer NOT NULL,
    name character varying
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: department_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_department_id_seq OWNER TO postgres;

--
-- Name: department_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_department_id_seq OWNED BY public.department.department_id;


--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    name character varying,
    surname character varying,
    age integer,
    gender character varying,
    contact_no character varying,
    company_id integer NOT NULL,
    store_id integer NOT NULL,
    department_id integer NOT NULL,
    salary integer
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employee_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_company_id_seq OWNER TO postgres;

--
-- Name: employee_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_company_id_seq OWNED BY public.employee.company_id;


--
-- Name: employee_count; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_count (
    id integer NOT NULL,
    status text
);


ALTER TABLE public.employee_count OWNER TO postgres;

--
-- Name: employee_count_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_count_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_count_id_seq OWNER TO postgres;

--
-- Name: employee_count_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_count_id_seq OWNED BY public.employee_count.id;


--
-- Name: employee_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_department_id_seq OWNER TO postgres;

--
-- Name: employee_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_department_id_seq OWNED BY public.employee.department_id;


--
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_employee_id_seq OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_employee_id_seq OWNED BY public.employee.employee_id;


--
-- Name: employee_store_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_store_id_seq OWNER TO postgres;

--
-- Name: employee_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_store_id_seq OWNED BY public.employee.store_id;


--
-- Name: hire_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hire_info (
    info character varying(150)
);


ALTER TABLE public.hire_info OWNER TO postgres;

--
-- Name: low_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.low_product (
    product_id integer NOT NULL,
    name character varying,
    price integer,
    stock integer
);


ALTER TABLE public.low_product OWNER TO postgres;

--
-- Name: model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model (
    model_id integer NOT NULL,
    name character varying,
    color character varying,
    supplier_id integer
);


ALTER TABLE public.model OWNER TO postgres;

--
-- Name: model_model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.model_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.model_model_id_seq OWNER TO postgres;

--
-- Name: model_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.model_model_id_seq OWNED BY public.model.model_id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
    name character varying,
    price integer,
    stock integer,
    supplier_id integer NOT NULL,
    variety_id integer NOT NULL,
    brand_id integer NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_brand_id_seq OWNER TO postgres;

--
-- Name: product_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product.brand_id;


--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    name text NOT NULL,
    total_stock integer
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    store_id integer NOT NULL,
    city character varying,
    company_id integer NOT NULL
);


ALTER TABLE public.store OWNER TO postgres;

--
-- Name: store_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_company_id_seq OWNER TO postgres;

--
-- Name: store_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_company_id_seq OWNED BY public.store.company_id;


--
-- Name: store_store_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_store_id_seq OWNER TO postgres;

--
-- Name: store_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_store_id_seq OWNED BY public.store.store_id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    supplier_id integer NOT NULL,
    name character varying,
    region character varying,
    contact_no character varying,
    contact_person character varying
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Name: supplier_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_supplier_id_seq OWNER TO postgres;

--
-- Name: supplier_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_supplier_id_seq OWNED BY public.supplier.supplier_id;


--
-- Name: variety; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variety (
    variety_id integer NOT NULL,
    name character varying
);


ALTER TABLE public.variety OWNER TO postgres;

--
-- Name: variety_variety_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.variety_variety_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variety_variety_id_seq OWNER TO postgres;

--
-- Name: variety_variety_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.variety_variety_id_seq OWNED BY public.variety.variety_id;


--
-- Name: customer customer_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer ALTER COLUMN customer_id SET DEFAULT nextval('customer.customer_customer_id_seq'::regclass);


--
-- Name: individual customer_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.individual ALTER COLUMN customer_id SET DEFAULT nextval('customer.individual_customer_id_seq'::regclass);


--
-- Name: institutional customer_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.institutional ALTER COLUMN customer_id SET DEFAULT nextval('customer.institutional_customer_id_seq'::regclass);


--
-- Name: cash payment_id; Type: DEFAULT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.cash ALTER COLUMN payment_id SET DEFAULT nextval('payment.cash_payment_id_seq'::regclass);


--
-- Name: debit_card payment_id; Type: DEFAULT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.debit_card ALTER COLUMN payment_id SET DEFAULT nextval('payment.debit_card_payment_id_seq'::regclass);


--
-- Name: payment payment_id; Type: DEFAULT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.payment ALTER COLUMN payment_id SET DEFAULT nextval('payment.payment_payment_id_seq'::regclass);


--
-- Name: payment customer_id; Type: DEFAULT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.payment ALTER COLUMN customer_id SET DEFAULT nextval('payment.payment_customer_id_seq'::regclass);


--
-- Name: payment variety_id; Type: DEFAULT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.payment ALTER COLUMN variety_id SET DEFAULT nextval('payment.payment_variety_id_seq'::regclass);


--
-- Name: brand brand_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand ALTER COLUMN brand_id SET DEFAULT nextval('public.brand_brand_id_seq'::regclass);


--
-- Name: brand supplier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand ALTER COLUMN supplier_id SET DEFAULT nextval('public.brand_supplier_id_seq'::regclass);


--
-- Name: company company_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN company_id SET DEFAULT nextval('public.company_company_id_seq'::regclass);


--
-- Name: department department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN department_id SET DEFAULT nextval('public.department_department_id_seq'::regclass);


--
-- Name: employee employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN employee_id SET DEFAULT nextval('public.employee_employee_id_seq'::regclass);


--
-- Name: employee company_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN company_id SET DEFAULT nextval('public.employee_company_id_seq'::regclass);


--
-- Name: employee store_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN store_id SET DEFAULT nextval('public.employee_store_id_seq'::regclass);


--
-- Name: employee department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN department_id SET DEFAULT nextval('public.employee_department_id_seq'::regclass);


--
-- Name: employee_count id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_count ALTER COLUMN id SET DEFAULT nextval('public.employee_count_id_seq'::regclass);


--
-- Name: model model_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model ALTER COLUMN model_id SET DEFAULT nextval('public.model_model_id_seq'::regclass);


--
-- Name: store store_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store ALTER COLUMN store_id SET DEFAULT nextval('public.store_store_id_seq'::regclass);


--
-- Name: store company_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store ALTER COLUMN company_id SET DEFAULT nextval('public.store_company_id_seq'::regclass);


--
-- Name: supplier supplier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN supplier_id SET DEFAULT nextval('public.supplier_supplier_id_seq'::regclass);


--
-- Name: variety variety_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety ALTER COLUMN variety_id SET DEFAULT nextval('public.variety_variety_id_seq'::regclass);


--
-- Data for Name: customer; Type: TABLE DATA; Schema: customer; Owner: postgres
--

INSERT INTO customer.customer VALUES
	(1, 'Hazal', 'Tuğrul', 'individual', 'Ankara', 'örnek@gmail.com', '08765678767'),
	(2, 'Ayşenur', 'Yılmaz', 'individual', 'Bolu', 'örnek2@gmail.com', '07656546543');


--
-- Data for Name: individual; Type: TABLE DATA; Schema: customer; Owner: postgres
--



--
-- Data for Name: institutional; Type: TABLE DATA; Schema: customer; Owner: postgres
--



--
-- Data for Name: cash; Type: TABLE DATA; Schema: payment; Owner: postgres
--



--
-- Data for Name: debit_card; Type: TABLE DATA; Schema: payment; Owner: postgres
--



--
-- Data for Name: payment; Type: TABLE DATA; Schema: payment; Owner: postgres
--

INSERT INTO payment.payment VALUES
	(1, 1, 22000, 1, 'individual', 'Lenovo Yoga Slim7', 1),
	(2, 2, 10000, 2, 'individual', 'Soundcore', 1),
	(3, 2, 100, 2, 'individual', 'Oppo Headphone', 2);


--
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.brand VALUES
	(1, 'Lenovo', 1),
	(2, 'Huawei', 2),
	(3, 'HP', 2);


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.company VALUES
	(1, 'HAM IT', 'ANKARA', '05647453243');


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department VALUES
	(1, 'IT'),
	(2, 'Sales'),
	(3, 'Manager'),
	(4, 'Cleaner');


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employee VALUES
	(1, 'Gürbüz', 'Yılmaz', 47, 'Male', '08765456765', 1, 2, 2, 50000),
	(2, 'Erhan', 'Saffar', 31, 'Male', '07654324252', 1, 3, 1, 100000),
	(3, 'Yaren ', 'Dağ', 24, 'Female', '07654321232', 1, 1, 3, 80000),
	(4, 'Ayşa', 'Hatun', 22, 'Female', '098765434567', 1, 3, 1, 150000),
	(5, 'Merve', 'Akdeniz', 21, 'Female', '09878765432', 1, 2, 2, 23400),
	(6, 'Nursel', 'Abay', 20, 'Female', '01237654567', 1, 3, 2, 9000);


--
-- Data for Name: employee_count; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employee_count VALUES
	(6, NULL);


--
-- Data for Name: hire_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hire_info VALUES
	('İşçi al');


--
-- Data for Name: low_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.low_product VALUES
	(4, 'Soundcore', 1200, 10);


--
-- Data for Name: model; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.model VALUES
	(1, 'Matebook 14', 'Gray', 2),
	(2, 'Yoga Slim7', 'Gray', 1),
	(3, 'Pavillion', 'Gray', 2);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product VALUES
	(1, 'Lenovo Yoga Slim7', 147389, 15, 1, 1, 1),
	(2, 'Huawei Matebook 14', 167480, 20, 2, 1, 1),
	(3, 'Hp Pavillion', 334959, 17, 1, 1, 1),
	(4, 'Soundcore', 8040, 10, 1, 2, 1);


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stock VALUES
	('Hp Pavillion', 17),
	('Soundcore', 10);


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.store VALUES
	(1, 'İstanbul', 1),
	(2, 'Ankara', 1),
	(3, 'Bolu', 1);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supplier VALUES
	(1, 'BIT IT', 'Black Sea', '0987654335', 'Hazal'),
	(2, 'YILMAZ IT', 'Aegean', '0765454545', 'Meryem');


--
-- Data for Name: variety; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.variety VALUES
	(1, 'Laptop'),
	(2, 'Headphones
'),
	(3, 'Phone'),
	(4, 'SmartWatch');


--
-- Name: customer_customer_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.customer_customer_id_seq', 4, true);


--
-- Name: individual_customer_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.individual_customer_id_seq', 1, false);


--
-- Name: institutional_customer_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.institutional_customer_id_seq', 1, false);


--
-- Name: cash_payment_id_seq; Type: SEQUENCE SET; Schema: payment; Owner: postgres
--

SELECT pg_catalog.setval('payment.cash_payment_id_seq', 1, false);


--
-- Name: debit_card_payment_id_seq; Type: SEQUENCE SET; Schema: payment; Owner: postgres
--

SELECT pg_catalog.setval('payment.debit_card_payment_id_seq', 1, false);


--
-- Name: payment_customer_id_seq; Type: SEQUENCE SET; Schema: payment; Owner: postgres
--

SELECT pg_catalog.setval('payment.payment_customer_id_seq', 1, false);


--
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: payment; Owner: postgres
--

SELECT pg_catalog.setval('payment.payment_payment_id_seq', 1, false);


--
-- Name: payment_variety_id_seq; Type: SEQUENCE SET; Schema: payment; Owner: postgres
--

SELECT pg_catalog.setval('payment.payment_variety_id_seq', 1, false);


--
-- Name: brand_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brand_brand_id_seq', 1, false);


--
-- Name: brand_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brand_supplier_id_seq', 1, false);


--
-- Name: company_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_company_id_seq', 1, false);


--
-- Name: department_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_department_id_seq', 1, false);


--
-- Name: employee_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_company_id_seq', 1, true);


--
-- Name: employee_count_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_count_id_seq', 1, false);


--
-- Name: employee_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_department_id_seq', 2, true);


--
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_employee_id_seq', 1, false);


--
-- Name: employee_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_store_id_seq', 2, true);


--
-- Name: model_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.model_model_id_seq', 1, false);


--
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 1, false);


--
-- Name: store_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_company_id_seq', 1, false);


--
-- Name: store_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_store_id_seq', 1, false);


--
-- Name: supplier_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_supplier_id_seq', 1, false);


--
-- Name: variety_variety_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.variety_variety_id_seq', 1, false);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: individual individual_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.individual
    ADD CONSTRAINT individual_pkey PRIMARY KEY (customer_id);


--
-- Name: institutional institutional_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.institutional
    ADD CONSTRAINT institutional_pkey PRIMARY KEY (customer_id);


--
-- Name: cash cash_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.cash
    ADD CONSTRAINT cash_pkey PRIMARY KEY (payment_id);


--
-- Name: debit_card debit_card_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.debit_card
    ADD CONSTRAINT debit_card_pkey PRIMARY KEY (payment_id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: brand brandPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT "brandPK" PRIMARY KEY (brand_id) INCLUDE (brand_id);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (company_id);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (department_id);


--
-- Name: employee_count employee_count_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_count
    ADD CONSTRAINT employee_count_pkey PRIMARY KEY (id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: low_product lowproduct_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.low_product
    ADD CONSTRAINT lowproduct_pk PRIMARY KEY (product_id);


--
-- Name: model model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT model_pkey PRIMARY KEY (model_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (name);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (store_id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- Name: variety variety_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT variety_pkey PRIMARY KEY (variety_id);


--
-- Name: fki_individual; Type: INDEX; Schema: customer; Owner: postgres
--

CREATE INDEX fki_individual ON customer.individual USING btree (customer_id);


--
-- Name: fki_institutionalFK; Type: INDEX; Schema: customer; Owner: postgres
--

CREATE INDEX "fki_institutionalFK" ON customer.institutional USING btree (customer_id);


--
-- Name: fki_cashFK; Type: INDEX; Schema: payment; Owner: postgres
--

CREATE INDEX "fki_cashFK" ON payment.cash USING btree (payment_id);


--
-- Name: fki_debit_card; Type: INDEX; Schema: payment; Owner: postgres
--

CREATE INDEX fki_debit_card ON payment.debit_card USING btree (payment_id);


--
-- Name: fki_EmployeeFK1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_EmployeeFK1" ON public.employee USING btree (company_id);


--
-- Name: fki_brandFK; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_brandFK" ON public.brand USING btree (supplier_id);


--
-- Name: fki_employeeFK2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_employeeFK2" ON public.employee USING btree (department_id);


--
-- Name: fki_employeeFK3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_employeeFK3" ON public.employee USING btree (store_id);


--
-- Name: fki_modelFK; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_modelFK" ON public.model USING btree (supplier_id);


--
-- Name: fki_productFK3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_productFK3" ON public.product USING btree (variety_id);


--
-- Name: fki_productFK4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_productFK4" ON public.product USING btree (brand_id);


--
-- Name: fki_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_s ON public.product USING btree (supplier_id);


--
-- Name: fki_storeFK; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_storeFK" ON public.store USING btree (company_id);


--
-- Name: product create_low_stock_record; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER create_low_stock_record AFTER INSERT ON public.product FOR EACH ROW EXECUTE FUNCTION public.create_low_stock_record();


--
-- Name: employee update_employee_count_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_employee_count_trigger AFTER INSERT OR DELETE ON public.employee FOR EACH ROW EXECUTE FUNCTION public.update_employee_count();


--
-- Name: employee_count update_hire_info; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_hire_info AFTER UPDATE ON public.employee_count FOR EACH ROW EXECUTE FUNCTION public.update_hire_info();


--
-- Name: product update_stock_table; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_stock_table AFTER INSERT ON public.product FOR EACH ROW EXECUTE FUNCTION public.update_stock_table();


--
-- Name: individual individual; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.individual
    ADD CONSTRAINT individual FOREIGN KEY (customer_id) REFERENCES customer.customer(customer_id) NOT VALID;


--
-- Name: institutional institutionalFK; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.institutional
    ADD CONSTRAINT "institutionalFK" FOREIGN KEY (customer_id) REFERENCES customer.customer(customer_id) NOT VALID;


--
-- Name: cash cashFK; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.cash
    ADD CONSTRAINT "cashFK" FOREIGN KEY (payment_id) REFERENCES payment.payment(payment_id) NOT VALID;


--
-- Name: debit_card debit_card; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.debit_card
    ADD CONSTRAINT debit_card FOREIGN KEY (payment_id) REFERENCES payment.payment(payment_id) NOT VALID;


--
-- Name: employee EmployeeFK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "EmployeeFK1" FOREIGN KEY (company_id) REFERENCES public.company(company_id) NOT VALID;


--
-- Name: brand brandFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT "brandFK" FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id) NOT VALID;


--
-- Name: employee employeeFK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "employeeFK2" FOREIGN KEY (department_id) REFERENCES public.department(department_id) NOT VALID;


--
-- Name: employee employeeFK3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "employeeFK3" FOREIGN KEY (store_id) REFERENCES public.store(store_id) NOT VALID;


--
-- Name: model modelFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT "modelFK" FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id) NOT VALID;


--
-- Name: product productFK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "productFK1" FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id) NOT VALID;


--
-- Name: product productFK3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "productFK3" FOREIGN KEY (variety_id) REFERENCES public.variety(variety_id) NOT VALID;


--
-- Name: product productFK4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "productFK4" FOREIGN KEY (brand_id) REFERENCES public.brand(brand_id) NOT VALID;


--
-- Name: store storeFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT "storeFK" FOREIGN KEY (company_id) REFERENCES public.company(company_id) NOT VALID;


--
-- PostgreSQL database dump complete
--

