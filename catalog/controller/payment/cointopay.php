<?php
class ControllerPaymentCoinToPay extends Controller {
	public function index() {
		$data['button_confirm'] = $this->language->get('button_confirm');
                
		$this->load->model('checkout/order');

		$order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);

                if (($this->request->server['REQUEST_METHOD'] == 'POST')) {
                    
                        //$this->response->redirect($this->c2pCreateInvoice($this->request->post));
                        

                        
                        $url = trim($this->c2pCreateInvoice($this->request->post)).'&output=json';
                        $ch = curl_init($url);
                        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 3);
                        $output = curl_exec($ch);
                        curl_close($ch);

                        $php_arr = json_decode($output);

                        $data1 = array();    
                        
                        $this->load->language('payment/cointopay_invoice');   
                        
                        if($php_arr->error == '' || empty($php_arr->error))
                        {
                            $this->model_checkout_order->addOrderHistory($php_arr->CustomerReferenceNr, $this->config->get('cointopay_order_status_id'));
                        
                            $data1['TransactionID'] = $php_arr->TransactionID;
                            $data1['coinAddress'] = $php_arr->coinAddress;
                            $data1['Amount'] = $php_arr->Amount;
                            $data1['CoinName'] = $php_arr->CoinName;
                            $data1['QRCodeURL'] = $php_arr->QRCodeURL;
                            $data1['RedirectURL'] = $php_arr->RedirectURL;
                            
                            $data1['text_title'] = $this->language->get('text_title');
                            $data1['text_transaction_id'] = $this->language->get('text_transaction_id');
                            $data1['text_address'] = $this->language->get('text_address');
                            $data1['text_amount'] = $this->language->get('text_amount');
                            $data1['text_coinname'] = $this->language->get('text_coinname');
                            $data1['text_pay_with_other'] = $this->language->get('text_pay_with_other');
                            $data1['text_clickhere'] = $this->language->get('text_clickhere');

                        }else{
                            $data1['error'] = $php_arr->error;
                        }
                        if (isset($this->session->data['order_id'])) {
                                $query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "order` WHERE order_id = '" . (int)$this->session->data['order_id'] . "' AND order_status_id > 0");

                                if ($query->num_rows) {
                                        $this->cart->clear();

                                        unset($this->session->data['shipping_method']);
                                        unset($this->session->data['shipping_methods']);
                                        unset($this->session->data['payment_method']);
                                        unset($this->session->data['payment_methods']);
                                        unset($this->session->data['guest']);
                                        unset($this->session->data['comment']);
                                        unset($this->session->data['order_id']);	
                                        unset($this->session->data['coupon']);
                                        unset($this->session->data['reward']);
                                        unset($this->session->data['voucher']);
                                        unset($this->session->data['vouchers']);
                                }
                        }
                        $data1['footer'] = $this->load->controller('common/footer');
                        $data1['header'] = $this->load->controller('common/header');
                        if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/payment/cointopay_invoice.tpl')) {
                                $this->response->setOutput($this->load->view($this->config->get('config_template') . '/template/payment/cointopay_invoice.tpl', $data1));
                        } else {
                                $this->response->setOutput($this->load->view('default/template/payment/cointopay_invoice.tpl', $data1));
                        }
		}else{
                
                    $this->load->language('payment/cointopay');    
                    
                    $data['action'] = $this->url->link('payment/cointopay');

                    $data['price'] = $this->currency->format($order_info['total'], $order_info['currency_code'], $order_info['currency_value'], false);
                    $data['key'] = $this->config->get('cointopay_api_key');
                    $data['AltCoinID'] = $this->config->get('cointopay_crypto_coin');
                    $data['crypto_coins'] = $this->getMerchantCoins($this->config->get('cointopay_merchantID'));
                    $data['OrderID'] = $this->session->data['order_id'];
                    $data['currency'] = $order_info['currency_code'];
                    
                    $data['text_crypto_coin_lable'] = $this->language->get('text_crypto_coin_lable');

                    if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/payment/cointopay.tpl')) {
                            return $this->load->view($this->config->get('config_template') . '/template/payment/cointopay.tpl', $data);
                    } else {
                            return $this->load->view('default/template/payment/cointopay.tpl', $data);
                    }
                }
	}

	public function callback() {
            $data = array();
            $this->load->language('payment/cointopay_invoice');
		if (isset($this->request->get['?CustomerReferenceNr']) && isset($this->request->get['TransactionID']) && isset($this->request->get['status'])) {
			$this->load->model('checkout/order');
                        
                        
                        if($this->request->get['status'] == 'paid')
                        {
                            $this->model_checkout_order->addOrderHistory($this->request->get['?CustomerReferenceNr'], $this->config->get('cointopay_callback_success_order_status_id'));
                        }  elseif ($this->request->get['status'] == 'failed') {
                            $this->model_checkout_order->addOrderHistory($this->request->get['?CustomerReferenceNr'], $this->config->get('cointopay_callback_failed_order_status_id'));
                        }
                        
                        $data['text_success'] = $this->language->get('text_success');
                        $data['footer'] = $this->load->controller('common/footer');
                        $data['header'] = $this->load->controller('common/header');
                        
                        if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/payment/cointopay_success.tpl')) {
                                $this->response->setOutput($this->load->view($this->config->get('config_template') . '/template/payment/cointopay_success.tpl', $data));
                        } else {
                                $this->response->setOutput($this->load->view('default/template/payment/cointopay_success.tpl', $data));
                        }
		}
	}
        
        function c2pCreateInvoice($data) {
//                $response = c2pCurl('https://cointopay.com/REAPI?key='.$options['apiKey'].'&price='.$options['price'].'&AltCoinID='.$options['defaultCoin'].'&OrderID='.$options['orderID'].'&inputCurrency='.$options['currency'], $options['apiKey'], $post);
                $response = $this->c2pCurl('https://cointopay.com/REAPI?key='.$data['key'].'&price='.$data['price'].'&AltCoinID='.$data['AltCoinID'].'&OrderID='.$data['OrderID'].'&inputCurrency='.$data['currency'], $data['key']);
                
                return $response;
        }
    
        public function c2pCurl($url, $apiKey, $post = false) {

                $curl = curl_init($url);
                $length = 0;
                if ($post)
                {	
                        //curl_setopt($curl, CURLOPT_POST, 1);
                        curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
                        $length = strlen($post);
                }

                $uname = base64_encode($apiKey);
                $header = array(
                        'Content-Type: application/json',
                        "Content-Length: $length",
                        "Authorization: Basic $uname",
                        );

                curl_setopt($curl, CURLOPT_PORT, 443);
                curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
                curl_setopt($curl, CURLOPT_TIMEOUT, 20);
                curl_setopt($curl, CURLOPT_VERBOSE, true);
                curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC ) ;
                curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, './'.$this->config->get('firstdata_api_key')); // verify certificate
                curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 2); // check existence of CN and verify that it matches hostname
                curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($curl, CURLOPT_FORBID_REUSE, 1);
                curl_setopt($curl, CURLOPT_FRESH_CONNECT, 1);

                $responseString = curl_exec($curl);

                if($responseString == false) {
                        $response = curl_error($curl);
                } else {
                        $response = $responseString;//json_decode($responseString, true);
                }
                curl_close($curl);
                return $response;
        }
        
        function getMerchantCoins($merchantId)
        {
            $url = 'https://cointopay.com/CloneMasterTransaction?MerchantID='.$merchantId.'&output=json';
            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 3);
            $output = curl_exec($ch);
            curl_close($ch);

            $php_arr = json_decode($output);
            $new_php_arr = array();
            
            if(count($php_arr)>0)
            {
                for($i=0;$i<count($php_arr)-1;$i++)
                {
                    if(($i%2)==0)
                    {
                        $new_php_arr[$php_arr[$i+1]] = $php_arr[$i];
                    }
                }
            }
            return $new_php_arr;
        }
}

